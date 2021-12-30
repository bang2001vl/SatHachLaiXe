import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sathachlaixe/console.dart';
import 'package:sathachlaixe/main.dart';

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
