import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';

class PracticeController {
  final String tableName = 'practice';
  PracticeController();

  Future<int> insert(PracticeModel data) async {
    var db = await AppConfig().openDB();
    var values = data.toJSON_insert();
    values["create_time"] = DateTime.now().toUtc().millisecondsSinceEpoch;
    return db.insert(tableName, values);
  }

/**Count how many question has been practice in input list*/
  Future<int> countHasPraticed(List<int> questionIds) async {
    var db = await AppConfig().openDB();
    var argsPlaceholder = questionIds.map((e) => "?").join(",");
    String sql =
        "SELECT count(id) FROM $tableName WHERE questionId IN $argsPlaceholder AND selectedAnswer > 0";

    return db.rawQuery(sql, questionIds).then((reader) {
      log(reader.toString());
      return reader.first["count"] as int;
    });
  }
}
