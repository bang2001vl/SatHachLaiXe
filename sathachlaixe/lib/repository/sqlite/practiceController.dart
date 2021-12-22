import 'dart:async';
import 'dart:core';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';

class PracticeController {
  final String tableName = 'practice';
  PracticeController();

  Future<int> insert(PracticeModel data) async {
    var db = await AppConfig().openDB();
    var values = data.toJSONinsert();
    values["create_time"] = DateTime.now().toUtc().millisecondsSinceEpoch;
    return db.insert(tableName, values);
  }

  Future<List<PracticeModel>> getPratice(int questionId) async {
    var db = await AppConfig().openDB();
    String sql = "SELECT * FROM $tableName WHERE questionId = ?";
    var data = await db.rawQuery(sql, [questionId]);

    data.forEach((element) {
      log(element.toString());
    });

    return data.map((row) => PracticeModel.fromJSON(row)).toList();
  }

  Future<int> update(PracticeModel data) async {
    var db = await AppConfig().openDB();
    var values = data.toJSONinsert();
    values["update_time"] = DateTime.now().toUtc().millisecondsSinceEpoch;
    return db.update(tableName, values, where: "id = ?", whereArgs: [data.id]);
  }

  Future<int> insertOrUpdate(
      int questionId, int selectedAnswer, int correctAnswer) async {
    var old = await getPratice(questionId);
    if (old.isEmpty) {
      var data = PracticeModel(questionId, selectedAnswer, correctAnswer, 0, 0);
      return insert(data);
    } else {
      var data = old.first;
      data.selectedAnswer = selectedAnswer;
      data.correctAnswer = correctAnswer;
      return update(data);
    }
  }

  /// Count how many question has been practice in input list*/
  Future<int> countHasPraticed(List<int> questionIds) async {
    var db = await AppConfig().openDB();
    var argsPlaceholder = questionIds.map((e) => "?").join(",");
    String sql =
        "SELECT id FROM $tableName WHERE questionId IN ($argsPlaceholder) AND selectedAnswer > 0";

    return db.rawQuery(sql, questionIds).then((reader) {
      return reader.length;
    });
  }
}
