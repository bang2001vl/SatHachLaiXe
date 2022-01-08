import 'dart:async';
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

  static const request_get_unsync = "get_unsync_data";
  static const response_get_unsync = "response_unsync_data";

  static const request_insert_data = "notify_change_data";
  static const response_notify_changed = "responsed_notify_data_changed";

  static const update_userInfo = "update_userInfo";
  static const request_get_userInfo = "get_userInfo";
  static const response_get_userInfo = "response_userInfo";

  static const request_deleted_data = "delete_data";

  static const event_data_changed = "data_changed";
  static const event_userinfo_changed = "userInfo_changed";
  static const event_deleted_data = "deleted_sync_data";

  static const event_authorize = "authorize";
  static const event_authorized = "authorized";
  static const event_failed_authorized = "authorize_failed";

  IO.Socket? _socket;

  bool get isConnected => _socket == null ? false : _socket!.connected;

  FutureOr<int> deleteData() {
    if (_socket == null) {
      return 0;
    }
    if (!_socket!.connected) {
      cannotConnect();
      return 0;
    }
    _socket?.emit(request_deleted_data);
    return 1;
  }

  Future<void> _updateData(
      List<HistoryModel> newHistories, List<PracticeModel> newPratices) async {
    for (int i = 0; i < newHistories.length; i++) {
      await repository.insertHistory(
        newHistories[i],
        needUpdateCount: false,
        needNoti: false,
      );
    }

    for (int i = 0; i < newPratices.length; i++) {
      var practice = newPratices[i];
      await repository.insertOrUpdatePractice(
        practice,
        needNoti: false,
      );
    }
  }

  void notifyDataChanged() async {
    log("SocketIO: notifyDataChanged");
    // if (_socket == null) {
    //   return;
    // }
    if (!repository.isSyncON) {
      return;
    }
    if (!repository.isAuthorized) {
      var resultLogin = await repository.auth.autoLogin();
      if (resultLogin != 1) {
        if (resultLogin == -1) {
          var rs = await showYesNoDialog("Đồng bộ thất bại",
              "Có lỗi xảy ra khi đồng bộ", "Tắt đồng bộ", "Thoát",
              willPopUp: false);
          if (rs == 1) {
            repository.updateSyncState(0);
          } else {
            this.close();
          }
        }
        return;
      }
    }
    // await connect();
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
    log("SocketIO: getUnsyncData");
    if (_socket == null) {
      log("ERROR: Call getUnsyncData() with null socket");
      return;
    }
    if (!_socket!.connected) {
      log("ERROR: Call getUnsyncData() with unconnect socket");
      return;
    }
    _socket?.on(response_get_unsync, _onResponseUnsyncData);

    var lastSync = await repository.getLastSyncTime();
    _socket?.emit(request_get_unsync, {"lastSync": lastSync});
  }

  void _onResponseUnsyncData(data) async {
// Unbind response's handler after got it
    _socket?.off(response_get_unsync);
    var jsonHistories = data["histories"] as List;
    var jsonPractices = data["practices"] as List;

    var jsonUserInfo = data["userInfo"];
    var sync_time = data["sync_time"] as int;
    if (jsonUserInfo != null) {
      var userInfo = UserModel.fromJSON(jsonUserInfo);
      await repository.updateUserInfo(userInfo);
      SocketBinding.instance.invokeOnUserInfoChanged();
      sync_time = Math.max(sync_time, userInfo.updateTime);
    }

    if (repository.isSyncON) {
      // Only sync when sync is ON

      if (jsonHistories.length > 0 || jsonPractices.length > 0) {
        var newHistories =
            jsonHistories.map((json) => HistoryModel.fromJSON(json)).toList();
        var newPratices =
            jsonPractices.map((json) => PracticeModel.fromJSON(json)).toList();

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

    await repository.updateLatestSyncTime(sync_time);
  }

  void updateUserInfo(String name, List<int>? rawimage) {
    if (_socket == null) {
      log("ERROR: Call updateUserInfo when socket = null");
      return;
    }
    log("SocketIO: Update userInfo");
    var data = Map();
    data["name"] = name;
    if (rawimage != null) {
      data["rawimage"] = rawimage;
    }
    log(data.toString());
    _socket!.emit(update_userInfo, data);
  }

  void _onUserInfoChanged(data) async {
    log("SocketIO: onUserInfoChanged");
    log(data.toString());
    var sync_time = await repository.getLastSyncTime();
    var userInfo = UserModel.fromJSON(data["userInfo"]);
    await repository.updateUserInfo(userInfo);
    SocketBinding.instance.invokeOnUserInfoChanged();
    sync_time = Math.max(sync_time, userInfo.updateTime);
    await repository.updateLatestSyncTime(sync_time);
  }

  void requestUserInfo() async {
    if (_socket == null) {
      log("ERROR: Call requestUserInfo when socket = null");
      return;
    }
    var socket = _socket!;
    socket.on(response_get_userInfo, (data) async {
      socket.off(response_get_userInfo);
      _onUserInfoChanged(data);
    });
    socket.emit(request_get_userInfo);
  }

  FutureOr<void> close() async {
    await repository.updateToken(null);

    log("SocketIO: Close connection");
    if (_socket == null) {
      return;
    }
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket = null;

    //SocketBinding.instance._invokeOnUserInfoChanged();
    SocketBinding.instance._invokeOnDisconnected();
  }

  SocketController._privateController();

  void init() {
    if (this._socket != null) return;
    if (AppConfig.instance.token == null) {
      log("SocketIO: Not found token");
      repository.auth.autoLogin();
      return;
    }
    log("SocketIO: Found token = " + AppConfig.instance.token!);
    var op = IO.OptionBuilder()
        .setTransports(['websocket'])
        // .setReconnectionAttempts(3)
        // .disableReconnection()
        .disableAutoConnect()
        //.enableForceNew()
        .setTimeout(2000)
        .build();

    IO.Socket socket = IO.io(this.url, op);

    socket.onConnectError((data) =>
        log("SocketIO: Connection failed with error: " + data.toString()));

    socket.onDisconnect((_) {
      log('SocketIO: disconnected');
      this.close();
    });

    socket.onConnect((_) async {
      log("SocketIO: onConnect");

      var temp = await getDeviceInfoJson();
      socket.emit(event_authorize, {
        "token": AppConfig.instance.token,
        "device": temp,
      });
    });

    socket.on(event_failed_authorized, (data) async {
      log("SocketIO: Authorized failed");
      await this.close();
      repository.auth.onUnauthorized();
    });

    socket.on(event_authorized, (data) {
      log("Authorized");
      showConnected();

      notifyDataChanged();
      getUnsyncData();

      SocketBinding.instance._invokeOnAuthorized();
      SocketBinding.instance.invokeOnUserInfoChanged();
    });

    socket.on(event_data_changed, (_) {
      log("SocketIO: onEventDataChanged");
      getUnsyncData();
    });

    socket.on(event_userinfo_changed, (data) {
      log("SocketIO: onEventUserInfoChanged");
      requestUserInfo();
    });

    socket.on(event_deleted_data, (_) async {
      var c = await repository.deleteAllLocalData();
      if (c > 0) {
        SocketBinding.instance._invokeDataChanged();
      }
    });

    socket.connect();
    this._socket = socket;

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

  void invokeOnUserInfoChanged() async {
    if (AppConfig.instance.userInfo != null) {
      var userInfo = AppConfig.instance.userInfo!;
      var maxTime = userInfo.latestDelete;
      if (maxTime >= await repository.getLastSyncTime()) {
        var c = await repository.deleteAllDataUntil(maxTime);
        if (c > 0) {
          SocketBinding.instance._invokeDataChanged();
        }
      }
    }
    _observers.forEach((element) {
      element.onUserInfoChanged();
    });
  }
}
