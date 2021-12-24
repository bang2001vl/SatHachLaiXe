import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

Future<List<Map<String, Object>>> getDateFromAsset(String key) async {
  final String raw =
      await rootBundle.loadString("assets/db_resource/board.tsv");

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
    log(values.toString());
    return values;
  });
}
