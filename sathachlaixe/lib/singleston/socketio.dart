import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as Math;

import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/model/user.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'socketObserver.dart';

class SocketController {
  //final String url = "http://192.168.1.110:9000";
  final String url = RepositoryGL.serverURL + ":9000";

  static const String request_get_unsync = "get_unsync_data";
  static const String response_get_unsync = "response_unsync_data";

  static const String request_insert_data = "notify_change_data";
  static const String response_notify_changed = "responsed_notify_data_changed";

  static const String request_deleted_data = "delete_data";

  static const String event_data_changed = "data_changed";
  static const String event_deleted_data = "deleted_sync_data";

  static const event_failed_authorized = "authorize_failed";
  static const String event_authorize = "authorize";
  static const String event_authorized = "authorized";

  IO.Socket? _socket;

  bool get isConnected => _socket == null ? false : _socket!.connected;

  void deleteData() {
    if (_socket == null) {
      return;
    }
    if (!_socket!.connected) {
      cannotConnect();
      return;
    }
    _socket?.emit(request_deleted_data);
  }

  Future<void> _updateData(
      List<HistoryModel> newHistories, List<PracticeModel> newPratices) async {
    for (int i = 0; i < newHistories.length; i++) {
      await repository.insertHistory(newHistories[i]);
    }

    for (int i = 0; i < newPratices.length; i++) {
      var practice = newPratices[i];
      await repository.insertOrUpdatePracticeAnswer(practice);
    }
  }

  void notifyDataChanged() async {
    if (_socket == null) {
      return;
    }
    if (!_socket!.connected) {
      return;
    }
    if (!repository.isSyncON) {
      return;
    }
    var newHistories = await repository.getUnsyncHistories();
    var newPratices = await repository.getUnsyncPractices();

    if (newHistories.length < 1 && newPratices.length < 1) return;
    log("SOCKETIO : Send new data to server");

    _socket?.on(response_notify_changed, _onResponseNotifyChanged);

    var mode = repository.getCurrentMode();
    var out1 = newHistories.map((e) {
      var j = e.toJSON();
      j["mode"] = mode;
      return j;
    }).toList();

    var out2 = newPratices.map((e) {
      var j = e.toJSON();
      j["mode"] = mode;
      return j;
    }).toList();

    _socket?.emit(request_insert_data, {
      "histories": out1,
      "practices": out2,
    });
  }

  void _onResponseNotifyChanged(data) async {
    // Unbind response's handler after got it
    _socket?.off(response_notify_changed);

    var rawHistories = data["histories"] as List;
    var rawPractices = data["practices"] as List;
    var histories = rawHistories.map((e) => HistoryModel.fromJSON(e)).toList();
    var practices = rawPractices.map((e) => PracticeModel.fromJSON(e)).toList();
    await repository.updateSyncTime(histories, practices);

    // Finnaly, update latest sync time
    var sync_time = await repository.getLastSyncTime();
    rawHistories.forEach((element) {
      sync_time = Math.max(sync_time, element["sync_time"]);
    });
    rawPractices.forEach((element) {
      sync_time = Math.max(sync_time, element["sync_time"]);
    });

    repository.updateLatestSyncTime(sync_time);
  }

  void getUnsyncData() async {
    if (_socket == null) {
      log("ERROR: Call getUnsyncData() with null socket");
      return;
    }
    if (!_socket!.connected) {
      log("ERROR: Call getUnsyncData() with unconnect socket");
      return;
    }
    _socket?.on(response_get_unsync, (data) async {
      // Unbind response's handler after got it
      _socket?.off(response_get_unsync);
      var jsonHistories = data["histories"] as List;
      var jsonPractices = data["practices"] as List;

      var jsonUserInfo = data["userInfo"];
      var sync_time = data["sync_time"] as int;
      if (jsonUserInfo != null) {
        var userInfo = UserModel.fromJSON(jsonUserInfo);
        await repository.updateUserInfo(userInfo);
        SocketBinding.instance._invokeOnUserInfoChanged();
        sync_time = Math.max(sync_time, userInfo.updateTime);
      }

      if (repository.isSyncON) {
        // Only sync when sync is ON

        if (jsonHistories.length > 0 || jsonPractices.length > 0) {
          var newHistories =
              jsonHistories.map((json) => HistoryModel.fromJSON(json)).toList();
          var newPratices = jsonPractices
              .map((json) => PracticeModel.fromJSON(json))
              .toList();

          await _updateData(newHistories, newPratices);

          SocketBinding.instance._invokeDataChanged();
        }
      }

      // Finnaly, update latest sync time
      sync_time = Math.max(sync_time, await repository.getLastSyncTime());
      jsonHistories.forEach((element) {
        sync_time = Math.max(sync_time, element["sync_time"]);
      });
      jsonPractices.forEach((element) {
        sync_time = Math.max(sync_time, element["sync_time"]);
      });

      repository.updateLatestSyncTime(sync_time);
    });

    var lastSync = await repository.getLastSyncTime();
    _socket?.emit(request_get_unsync, {"lastSync": lastSync});
  }

  FutureOr<void> close() async {
    if (_socket == null) {
      return;
    }
    _socket?.destroy();
    _socket = null;

    await repository.updateToken(null);

    SocketBinding.instance._invokeOnUserInfoChanged();
    SocketBinding.instance._invokeOnDisconnected();
  }

  SocketController._privateController();

  init() {
    if (this._socket != null) return;
    if (AppConfig.instance.token == null) {
      log("SocketIO: Not found token");
      repository.auth.onUnauthorized();
      return false;
    }

    var op = IO.OptionBuilder()
        .setTransports(['websocket'])
        // .setReconnectionAttempts(3)
        // .disableReconnection()
        //.disableAutoConnect()
        .enableForceNew()
        .build();

    IO.Socket socket = IO.io(this.url, op);
    this._socket = socket;

    socket.onConnectError((data) =>
        log("SocketIO: Connection failed with error: " + data.toString()));

    socket.onDisconnect((_) {
      log('disconnect');
    });

    socket.onConnect((_) async {
      log("SocketIO: onConnect");

      socket.emit(event_authorize, {
        "token": AppConfig.instance.token,
        "device": await getDeviceInfoJson(),
      });
    });

    socket.on(event_failed_authorized, (data) async {
      log("SocketIO: Authorized failed");
      await this.close();
      repository.auth.onUnauthorized();
    });

    socket.on(event_authorized, (data) async {
      log("Authorized");

      AppConfig.instance.userInfo = UserModel.fromJSON(data["userInfo"]);
      AppConfig.instance.saveUserInfo(AppConfig.instance.userInfo!);

      notifyDataChanged();
      getUnsyncData();

      SocketBinding.instance._invokeOnAuthorized();
    });

    socket.on(event_data_changed, (_) => getUnsyncData());

    socket.on(event_deleted_data, (_) {
      repository.deleteAllData();
    });

    log("[OK] : Init socketIO");
  }

  void cannotConnect() {
    showNotifyMessage("Kết nối thất bại",
        "Không thể kết nối đến server. Vui lòng kiểm tra lại kết nối.");
  }

  static SocketController _instance = SocketController._privateController();
  static SocketController get instance => _instance;
  factory SocketController() => _instance;
}

class SocketBinding {
  static final SocketBinding _instance = SocketBinding();
  static SocketBinding get instance => _instance;

  SocketBinding() {
    _observers = List.empty(growable: true);
  }

  late List<SocketObserver> _observers;
  void addObserver(SocketObserver observer) {
    _observers.add(observer);
  }

  void removeObserver(SocketObserver observer) {
    _observers.remove(observer);
  }

  void _invokeDataChanged() {
    _observers.forEach((element) {
      element.onDataChanged();
    });
  }

  void _invokeOnAuthorized() {
    _observers.forEach((element) {
      element.onAuthorized();
    });
  }

  void _invokeOnDisconnected() {
    _observers.forEach((element) {
      element.onDisconnect();
    });
  }

  void _invokeOnUserInfoChanged() async {
    if (AppConfig.instance.userInfo != null) {
      var userInfo = AppConfig.instance.userInfo!;
      var maxTime = userInfo.latestDelete;
      if (maxTime >= await repository.getLastSyncTime()) {
        await repository.deleteAllDataUntil(maxTime);
      }
    }
    _observers.forEach((element) {
      element.onUserInfoChanged();
    });
  }
}
