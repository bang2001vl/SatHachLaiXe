import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sathachlaixe/console.dart';
import 'package:sathachlaixe/main.dart';
import 'package:sathachlaixe/singleston/repository.dart';

Future<List<Map<String, Object>>> getDataFromAsset(String key) async {
  final String raw = await rootBundle.loadString(key);

  final List<String> lines = const LineSplitter().convert(raw);
  // Lines[0] is column's name
  final columns = lines[0].split('\t');
  //log(lines[0]);
  // Get from lines[1] to the end
  return List.generate(lines.length - 1, (index) {
    final i = index + 1;
    final line = lines[i];
    final List<String> fields = line.split('\t');
    var values = Map<String, Object>.fromIterables(columns, fields);
    //log(line);
    //log(values.toString());
    return values;
  });
}

BuildContext getCurrentContext() {
  return navigatorKey.currentContext!;
}

Future<int?> showYesNoDialog(
    String title, String content, String btn1, String btn2,
    {FutureOr<bool> willPopUp = true}) {
  var context = getCurrentContext();
  return showDialog(
      context: context,
      builder: (context) => WillPopScope(
            onWillPop: () => Future.value(willPopUp),
            child: AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  child: Text(btn1),
                  onPressed: () => Navigator.pop(context, 1),
                ),
                TextButton(
                  child: Text(btn2),
                  onPressed: () => Navigator.pop(context, 2),
                ),
              ],
            ),
          ));
}

Future<int?> showNotifyMessage(String title, String content) {
  var context = getCurrentContext();
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context, 1),
              ),
            ],
          ));
}

Future<int?> notifyConnectionError() {
  var context = getCurrentContext();
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Kết nối thất bại"),
            content: const Text(
                "Không thể kết nối đến server. Vui lòng kiểm tra lại kết nối."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context, 1),
              ),
            ],
          ));
}

Future<void> notifyAutoLoginFailed() async {
  var context = getCurrentContext();
  var rs = await showDialog(
      context: context,
      builder: (context) => WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: const Text("Đăng nhập thất bại"),
              content: const Text("Có lỗi xảy ra trong quá trình đăng nhập"),
              actions: [
                TextButton(
                  child: const Text("Đăng xuất"),
                  onPressed: () {
                    repository.auth.logout();
                    Navigator.pop(context, 1);
                  },
                ),
                TextButton(
                  child: const Text("Thoát"),
                  onPressed: () => closeApplication(),
                ),
              ],
            ),
          ));
}

FutureOr<Map> getDeviceInfoJson() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final map = deviceInfo.toMap();
  map["systemFeatures"] = null;
  log("Get device info");
  log(map.toString());
  return map;
}

void closeApplication() {
  if (Platform.isAndroid) {
    SystemNavigator.pop();
  } else if (Platform.isIOS) {
    exit(0);
  }
}
