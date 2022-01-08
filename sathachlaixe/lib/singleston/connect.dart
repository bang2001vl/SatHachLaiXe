import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class MyConnectivity {
  MyConnectivity._internal() {
    _initialise();
  }

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void _initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    //_checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final addr = await InternetAddress.lookup(RepositoryGL.serverAddress);
      if (addr.isNotEmpty && addr[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add(isOnline);
  }

  void disposeStream() => controller.close();
}

// class MyConnectivityBinding {
//   static final MyConnectivityBinding _instance = MyConnectivityBinding();
//   static MyConnectivityBinding get instance => _instance;

//   late List<MyConnectivityObserver> _observers;
//   Connectivity connectivity = Connectivity();
//   MyConnectivityBinding() {
//     _observers = List.empty(growable: true);
//     _initialise();
//   }

//   void addObserver(MyConnectivityObserver observer) {
//     _observers.add(observer);
//   }

//   void removeObserver(MyConnectivityObserver observer) {
//     _observers.remove(observer);
//   }

//   late ConnectivityResult result;
//   void _initialise() async {
//     result = await connectivity.checkConnectivity();
//     checkStatus();
//     connectivity.onConnectivityChanged.listen((result) {
//       checkStatus();
//     });
//   }

//   void checkStatus() async {
//     bool isOnline = false;
//     try {
//       final result = await InternetAddress.lookup(RepositoryGL.serverURL);
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         isOnline = true;
//       } else {
//         isOnline = false;
//       }
//     } on SocketException catch (_) {
//       isOnline = false;
//     }
//     MyConnectivityBinding._instance._invokeDataChanged(isOnline);
//   }

//   void _invokeDataChanged(bool value) {
//     _observers.forEach((element) {
//       element.onConnectivityChanged(value);
//     });
//   }
// }

// abstract class MyConnectivityObserver {
//   onConnectivityChanged(bool isOnline);
// }
