import 'dart:async';
import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController {
  final String url = "http://192.168.1.110:9000";
  final String event_test = "test_client";
  final String event_authorize = "authorize";
  final String event_authorized = "authorized";

  late IO.Socket socket;
  late Timer timer;

  void connect() {
    if (timer.isActive) return;
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (socket.connected) {
        timer.cancel();
        return;
      }

      socket.connect();
    });
  }

  SocketController.privateController() {
    init();
  }

  void init() {
    var op = IO.OptionBuilder()
        .setTransports(['websocket'])
        .setReconnectionAttempts(3)
        .disableAutoConnect()
        .disableReconnection()
        .build();
    socket = IO.io(this.url, op);

    socket.onConnect((_) {
      log("SocketIO: onConnect");
      socket.emit(event_authorize, {
        "username": "temp",
        "token": "123465",
      });
    });

    socket.onConnectError((data) =>
        log("SocketIO: Connection failed with error: " + data.toString()));

    socket.on(event_authorized, (data) {
      log("Authorized");
    });
    socket.on(event_test, (data) => log("[OK] : Test socketIO client"));

    socket.onDisconnect((_) => log('disconnect'));
    socket.on('fromServer', (_) => log(_));

    log("[OK] : Init socketIO");
  }

  static SocketController _instance = SocketController.privateController();
  factory SocketController() => _instance;
}
