import 'dart:developer';

import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';

class HistoryController {
  final String tableName = 'history';

  HistoryController();

  Future<int> insertHistory(HistoryModel data) async {
    var db = await AppConfig().dbController.openDB();
    var values = data.toJSON_insert();
    values["create_time"] = DateTime.now().toUtc().microsecondsSinceEpoch;
    var affected = await db.insert(this.tableName, values);

    return affected;
  }

  Future<List<HistoryModel>> getHistoryList() async {
    var db = await AppConfig().dbController.openDB();
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
}
