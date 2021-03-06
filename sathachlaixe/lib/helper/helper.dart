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
            title: const Text("K???t n???i th???t b???i"),
            content: const Text(
                "Kh??ng th??? k???t n???i ?????n server. Vui l??ng ki???m tra l???i k???t n???i."),
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
              title: const Text("????ng nh???p th???t b???i"),
              content: const Text("C?? l???i x???y ra trong qu?? tr??nh ????ng nh???p"),
              actions: [
                TextButton(
                  child: const Text("????ng xu???t"),
                  onPressed: () {
                    repository.auth.logout();
                    Navigator.pop(context, 1);
                  },
                ),
                TextButton(
                  child: const Text("Tho??t"),
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

void showConnected() {
  var context = getCurrentContext();
  const snackBar = SnackBar(
    content: const Text('K???t n???i th??nh c??ng'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
