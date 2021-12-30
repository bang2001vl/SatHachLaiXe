import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/model/user.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'socketObserver.dart';

class SocketController {
  final String url = "http://192.168.1.110:9000";

  static const String request_get_unsync = "get_unsync_data";
  static const String response_get_unsync = "response_unsync_data";

  static const String request_insert_data = "notify_change_data";
  static const String response_notify_changed = "responsed_notify_data_changed";

  static const String request_deleted_data = "delete_data";

  static const String event_data_changed = "data_changed";
  static const String event_deleted_data = "deleted_sync_data";

  static const String event_test = "test_client";
  static const String event_authorize = "authorize";
  static const String event_authorized = "authorized";

  late IO.Socket socket;
  late Timer timer;

  void deleteData() {
    socket.emit(request_deleted_data);
  }

  Future<void> updateData(
      List<HistoryModel> newHistories, List<PracticeModel> newPratices) async {
    for (int i = 0; i < newHistories.length; i++) {
      await repository.insertHistory(newHistories[i]);
    }

    for (int i = 0; i < newPratices.length; i++) {
      var practice = newPratices[i];
      await repository.insertOrUpdatePractice(
        practice.questionID,
        practice.selectedAnswer,
        practice.correctAnswer,
        countCorrect: practice.countCorrect,
        countWrong: practice.countWrong,
      );
    }
  }

  void notifyDataChanged() async {
    if (socket.disconnected) return;
    var newHistories = await repository.getUnsyncHistories();
    var newPratices = await repository.getUnsyncPractices();

    if (newHistories.length < 1 && newPratices.length < 1) return;
    log("SOCKETIO : Send new data to server");

    socket.on(response_notify_changed, (data) async {
      var rawHistories = data["histories"] as List;
      var rawPractices = data["practices"] as List;
      var histories =
          rawHistories.map((e) => HistoryModel.fromJSON(e)).toList();
      var practices =
          rawPractices.map((e) => PracticeModel.fromJSON(e)).toList();
      await repository.updateSyncTime(histories, practices);

      // Unbind response's handler after got it
      socket.off(response_notify_changed);
    });

    var out1 = newHistories.map((e) => e.toJSON()).toList();
    var out2 = newPratices.map((e) => e.toJSON()).toList();

    socket.emit(request_insert_data, {
      "histories": out1,
      "practices": out2,
    });
  }

  void getUnsyncData() async {
    socket.on(response_get_unsync, (data) async {
      //int sync_time = data["sync_time"];
      var jsonHistories = data["histories"] as List;
      var jsonPractices = data["practices"] as List;

      if (jsonHistories.length < 1 && jsonPractices.length < 1) return;
      log("SOCKETIO : Received new data from server");

      var newHistories =
          jsonHistories.map((json) => HistoryModel.fromJSON(json)).toList();
      var newPratices =
          jsonPractices.map((json) => PracticeModel.fromJSON(json)).toList();

      await updateData(newHistories, newPratices);

      SocketBinding.instance._invokeDataChanged(newHistories, newPratices);

      // Unbind response's handler after got it
      socket.off(response_get_unsync);
    });

    var lastSync = await repository.getLastSyncTime();
    socket.emit(request_get_unsync, {"lastSync": lastSync});
  }

  SocketController._privateController();

  void init() {
    if (AppConfig.instance.token == null) {
      repository.auth.onUnauthorized();
      return;
    }

    var op = IO.OptionBuilder().setTransports(['websocket'])
        // .setReconnectionAttempts(3)
        // .disableReconnection()
        .build();
    socket = IO.io(this.url, op);

    socket.onConnect((_) {
      log("SocketIO: onConnect");
      socket.emit(event_authorize, {
        "token": AppConfig.instance.token,
      });
    });

    socket.onConnectError((data) =>
        log("SocketIO: Connection failed with error: " + data.toString()));

    socket.on(event_authorized, (data) async {
      log("Authorized");

      AppConfig.instance.userInfo = UserModel.fromJSON(data["userInfo"]);
      AppConfig.instance.saveUserInfo(AppConfig.instance.userInfo!);

      notifyDataChanged();
      getUnsyncData();
    });
    socket.on(event_test, (data) => log("[OK] : Test socketIO client"));

    socket.onDisconnect((_) {
      log('disconnect');
    });

    socket.on(event_data_changed, (_) => getUnsyncData());

    socket.on(event_deleted_data, (_) {
      repository.deleteAllData();
    });

    log("[OK] : Init socketIO");
  }

  void close() {
    socket.close();
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

  void _invokeDataChanged(
      List<HistoryModel> newHistories, List<PracticeModel> newPratices) {
    _observers.forEach((element) {
      element.onDataChanged(newHistories, newPratices);
    });
  }
}
