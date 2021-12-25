import 'dart:developer';

import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/repository/sqlite/questionStatistic.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class HistoryController {
  final String tableName = 'history';

  HistoryController();

  Future<int> insertHistory(HistoryModel data) async {
    var db = await AppConfig().openDB();
    var values = data.toJSON_insert();
    values["create_time"] = DateTime.now().toUtc().millisecondsSinceEpoch;
    values["update_time"] = values["create_time"];
    values["mode"] = repository.getCurrentMode();
    var affected = await db.insert(this.tableName, values);

    return affected;
  }

  Future<List<HistoryModel>> getHistoryAll() async {
    var db = await AppConfig().openDB();
    var mode = repository.getCurrentMode();
    var sql = "SELECT * FROM history WHERE mode = ?";
    var data = await db.rawQuery(sql, [mode]);

    var rs = List<HistoryModel>.generate(
        data.length, (index) => new HistoryModel.fromJSON(data[index]));

    data.forEach((element) {
      log(element.toString());
    });

    return rs;
  }

  Future<List<HistoryModel>> getLastestHistory(int topicId,
      {int count = 1}) async {
    var db = await AppConfig().openDB();
    var mode = repository.getCurrentMode();
    var sql =
        "SELECT * FROM $tableName WHERE mode = ? AND topicId  = ? ORDER BY create_time DESC LIMIT ?;";
    var data = await db.rawQuery(sql, [mode, topicId, count]);

    var rs = List<HistoryModel>.generate(
        data.length, (index) => new HistoryModel.fromJSON(data[index]));

    data.forEach((element) {
      log(element.toString());
    });

    return rs;
  }

  Future<List<HistoryModel?>> getLastestHistoryList(List<int> idList) async {
    var rs = List<HistoryModel?>.of([]);
    for (int i = 0; i < idList.length; i++) {
      var h = await getLastestHistory(idList[i]);
      if (h.isNotEmpty) {
        rs.add(h.first);
      } else {
        rs.add(null);
      }
    }
    return rs;
  }

  Future<List<HistoryModel>> getAllFinishedHistory() async {
    var db = await AppConfig().openDB();
    var mode = repository.getCurrentMode();
    var sql = "SELECT * FROM $tableName WHERE mode = ? AND isFinished = 1;";
    var data = await db.rawQuery(sql, [mode]);

    var rs = List<HistoryModel>.generate(
        data.length, (index) => new HistoryModel.fromJSON(data[index]));

    data.forEach((element) {
      log(element.toString());
    });

    return rs;
  }

  Future<Map<String, QuestionStatistic>> statisticQuestions() async {
    var histories = await getAllFinishedHistory();
    var rs = Map<String, QuestionStatistic>();
    histories.forEach((h) {
      for (int i = 0; i < h.questionIds.length; i++) {
        var quesId = h.questionIds[i];
        if (h.selectedAns[i] == h.correctAns[i]) {
          if (rs[quesId] == null) {
            rs[quesId] = QuestionStatistic(
                questionId: quesId, countCorrect: 1, countWrong: 0);
          } else {
            rs[quesId]?.countCorrect += 1;
          }
        } else {
          if (rs[quesId] == null) {
            rs[quesId] = QuestionStatistic(
                questionId: quesId, countCorrect: 0, countWrong: 1);
          } else {
            rs[quesId]?.countWrong += 1;
          }
        }
      }
    });
    return rs;
  }
}
