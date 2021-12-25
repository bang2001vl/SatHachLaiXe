import 'dart:async';
import 'dart:core';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class PracticeController {
  final String tableName = 'practice';
  PracticeController();

  Future<int> insert(PracticeModel data) async {
    var db = await AppConfig().openDB();
    var values = data.toJSONinsert();
    values["create_time"] = DateTime.now().toUtc().millisecondsSinceEpoch;
    values["update_time"] = values["create_time"]!;
    values["sync_time"] = 0;
    values["mode"] = repository.getCurrentMode();
    return db.insert(tableName, values);
  }

  Future<List<PracticeModel>> getPratice(int questionId) async {
    var db = await AppConfig().openDB();
    var mode = repository.getCurrentMode();
    String sql = "SELECT * FROM $tableName WHERE mode = ? AND questionId = ?";
    var data = await db.rawQuery(sql, [mode, questionId]);

    // data.forEach((element) {
    //   log(element.toString());
    // });

    return data.map((row) => PracticeModel.fromJSON(row)).toList();
  }

  Future<int> update(PracticeModel data) async {
    var db = await AppConfig().openDB();
    var values = data.toJSONinsert();
    values["update_time"] = DateTime.now().toUtc().millisecondsSinceEpoch;
    return db.update(tableName, values, where: "id = ?", whereArgs: [data.id]);
  }

  Future<int> insertOrUpdate(
    int questionId,
    int selectedAnswer,
    int correctAnswer, {
    int countWrong = 0,
    int countCorrect = 0,
  }) async {
    var old = await getPratice(questionId);
    if (old.isEmpty) {
      var data = PracticeModel(questionId, selectedAnswer, correctAnswer, 0, 0);
      return insert(data);
    } else {
      var data = old.first;
      data.selectedAnswer = selectedAnswer;
      data.correctAnswer = correctAnswer;
      data.countWrong = countWrong;
      data.countCorrect = countCorrect;
      return update(data);
    }
  }

  /// Count how many question has been practice in input list*/
  Future<int> countHasPraticed(List<int> questionIds) async {
    var db = await AppConfig().openDB();
    var mode = repository.getCurrentMode();
    var argsPlaceholder = questionIds.map((e) => "?").join(",");
    String sql =
        "SELECT id FROM $tableName WHERE mode = ? AND questionId IN ($argsPlaceholder) AND selectedAnswer > 0";

    var values = List<Object>.of([mode], growable: true);
    values.addAll(questionIds);
    return db.rawQuery(sql, values).then((reader) {
      return reader.length;
    });
  }

  Future<List<PracticeModel>> getUnsyncPractices() async {
    var db = await AppConfig().openDB();
    var lastSync = await getMaxSyncTime();
    var sql = "SELECT * FROM $tableName WHERE sync_time = 0 OR update_time > ?";
    var data = await db.rawQuery(sql, [lastSync]);

    var rs = List<PracticeModel>.generate(
        data.length, (index) => new PracticeModel.fromJSON(data[index]));

    data.forEach((element) {
      log(element.toString());
    });

    return rs;
  }

  Future<int> updateSyncTime(List<int> ids, int syncTime) async {
    var db = await AppConfig().openDB();
    var argsPlaceholder = ids.map((e) => "?").join(",");
    var sql =
        "UPDATE $tableName SET sync_time = ? WHERE id IN ($argsPlaceholder);";
    var values = List.empty(growable: true);
    values
      ..add(syncTime)
      ..addAll(ids);
    return db.rawUpdate(sql, values);
  }

  Future<int> getMaxSyncTime() async {
    var db = await AppConfig().openDB();
    var sql =
        "SELECT sync_time FROM $tableName ORDER BY sync_time DESC LIMIT 1;";
    var reader = await db.rawQuery(sql);
    if (reader.isEmpty) {
      return 0;
    }
    return reader.first["sync_time"] as int;
  }
}
