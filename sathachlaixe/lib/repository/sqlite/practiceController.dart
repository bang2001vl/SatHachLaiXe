import 'dart:core';
import 'dart:developer';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/repository/sqlite/questionStatistic.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class PracticeController {
  final String tableName = 'practice';
  PracticeController();

  Future<int> insert(PracticeModel data) async {
    log("Practice: Insert");
    var db = await AppConfig().openDB();
    var values = data.toJSON();

    if (values["create_time"] == null) {
      // First time, not sync
      values["create_time"] = DateTime.now().toUtc().millisecondsSinceEpoch;
      values["update_time"] = values["create_time"];
      values["sync_time"] = 0;
    }

    values["mode"] = repository.getCurrentMode();
    log(values.toString());
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

  Future<int> update(PracticeModel data, {bool updateTime = true}) async {
    log("Practice: Update");
    var db = await AppConfig().openDB();
    var values = data.toJSON();
    if (updateTime) {
      values["update_time"] = DateTime.now().toUtc().millisecondsSinceEpoch;
    }
    //log("Data = " + jsonEncode(data));
    log("Values = " + values.toString());
    return db.update(tableName, values, where: "id = ?", whereArgs: [data.id]);
  }

  Future<int> insertOrUpdate(PracticeModel model) async {
    var old = await getPratice(model.questionID);
    if (old.isEmpty) {
      if (model.selectedAnswer == model.correctAnswer) {
        model.countCorrect = 1;
        model.countWrong = 0;
      } else {
        model.countCorrect = 0;
        model.countWrong = 1;
      }
      return insert(model);
    } else {
      log("Practice: Update");
      model.id = old.first.id;
      return update(model, updateTime: false);
    }
  }

  /// Update
  Future<int> insertOrUpdateAnswer(PracticeModel model) async {
    var old = await getPratice(model.questionID);
    if (old.isEmpty) {
      if (model.selectedAnswer == model.correctAnswer) {
        model.countCorrect = 1;
        model.countWrong = 0;
      } else {
        model.countCorrect = 0;
        model.countWrong = 1;
      }
      return insert(model);
    } else {
      log("Practice: Update answer");
      var data = old.first;
      data.selectedAnswer = model.selectedAnswer;
      data.correctAnswer = model.correctAnswer;
      return update(data);
    }
  }

  Future<int> insertOrPlusCorrect(int questionID, int correct) async {
    var old = await getPratice(questionID);
    if (old.isEmpty) {
      return insert(PracticeModel(questionID, 0, -1, 0, 1));
    } else {
      var data = old.first;
      data.countCorrect++;
      if (data.countCorrect > 2) {
        data.correctAnswer = correct;
        data.selectedAnswer = data.correctAnswer;
      }
      return update(data);
    }
  }

  Future<int> plusWrong(int questionID) async {
    var old = await getPratice(questionID);
    if (old.isEmpty) {
      return insert(PracticeModel(questionID, 0, -1, 1, 0));
    } else {
      var data = old.first;
      data.countWrong++;
      return update(data);
    }
  }

  Future<List<QuestionStatistic>> statisticTopWrong(int count) async {
    var a = await getAll();
    a.removeWhere((element) => element.countWrong < 1);
    var l = a
        .map((e) => QuestionStatistic(
            questionId: e.questionID.toString(),
            countCorrect: e.countCorrect,
            countWrong: e.countWrong))
        .toList();
    // Sort by DECS
    l.sort((a, b) => b.countWrong.compareTo(a.countWrong));

    if (count < 0) {
      return l;
    }

    if (count > a.length) {
      count = a.length;
    }
    return l.sublist(0, count);
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

  Future<int> updateSyncTimeAll(List<PracticeModel> list) async {
    int rs = 0;
    for (int i = 0; i < list.length; i++) {
      rs += await updateSyncTime(list[i].create_time!, list[i].sync_time);
    }
    return rs;
  }

  Future<int> updateSyncTime(int createdTime, int? syncTime) async {
    var db = await AppConfig().openDB();
    var sql = "UPDATE $tableName SET sync_time = ? WHERE create_time = ?;";
    return db.rawUpdate(sql, [syncTime, createdTime]);
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

  Future<int> deleteAll() async {
    var db = await AppConfig().openDB();
    var sql = "DELETE FROM $tableName";
    var count = await db.rawDelete(sql);
    log("Delete from practice : " + count.toString());
    return count;
  }

  Future<int> deleteAllUntil(int maxTime) async {
    var db = await AppConfig().openDB();
    var sql = "DELETE FROM $tableName WHERE create_time < ?";
    var count = await db.rawDelete(sql, [maxTime]);
    log("Delete from history : " + count.toString());
    return count;
  }

  Future<List<PracticeModel>> getAll() async {
    var db = await AppConfig().openDB();
    var sql = "SELECT * FROM $tableName";
    var data = await db.rawQuery(sql);

    var rs = List<PracticeModel>.generate(
        data.length, (index) => new PracticeModel.fromJSON(data[index]));

    // data.forEach((element) {
    //   log(element.toString());
    // });

    return rs;
  }

  Future<List<PracticeModel>> getPracticeList(List<int> questionIds) async {
    var db = await AppConfig().openDB();
    var mode = repository.getCurrentMode();
    var argsPlaceholder = questionIds.map((e) => "?").join(",");
    String sql =
        "SELECT * FROM $tableName WHERE mode = ? AND questionId IN ($argsPlaceholder)";

    var values = List<Object>.of([mode], growable: true);
    values.addAll(questionIds);
    var reader = await db.rawQuery(sql, values);

    Map<int, PracticeModel> m = Map();
    reader.forEach((element) {
      var p = PracticeModel.fromJSON(element);
      m[p.questionID] = p;
    });

    return List.generate(questionIds.length, (i) {
      if (!m.containsKey(questionIds[i])) {
        return PracticeModel(questionIds[i], -1, -2, 0, 0);
      } else {
        return m[questionIds[i]]!;
      }
    });
  }
}
