import 'dart:developer';

import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/repository/sqlite/questionStatistic.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';

class HistoryController {
  final String tableName = 'history';

  HistoryController();

  Future<int> insertHistory(HistoryModel data) async {
    var db = await AppConfig().openDB();
    var values = data.toJSON_insert();
    values["create_time"] = DateTime.now().toUtc().millisecondsSinceEpoch;
    var affected = await db.insert(this.tableName, values);

    return affected;
  }

  Future<List<HistoryModel>> getHistoryList() async {
    var db = await AppConfig().openDB();
    var sql = "SELECT * FROM history WHERE topicId > 0;";
    var data = await db.rawQuery(sql);

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
    var sql =
        "SELECT * FROM history WHERE topicId  = ? ORDER BY create_time DESC LIMIT ?;";
    var data = await db.rawQuery(sql, [topicId, count]);

    var rs = List<HistoryModel>.generate(
        data.length, (index) => new HistoryModel.fromJSON(data[index]));

    data.forEach((element) {
      log(element.toString());
    });

    return rs;
  }

  Future<List<HistoryModel>> getAllFinishedHistory() async {
    var db = await AppConfig().openDB();
    var sql = "SELECT * FROM history WHERE isFinished = 1;";
    var data = await db.rawQuery(sql);

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
