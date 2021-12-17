import 'dart:developer';

import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/repository/sqlite/controller.dart';

class HistoryController {
  final String tableName = 'history';

  HistoryController();

  Future<int> insertHistory(HistoryModel data) async {
    var db = await DBController().openDB();
    var affected = await db.insert(this.tableName, {
      "isPassed": data.isPassed,
      "topicID": data.topicID,
      "rawCorrect": data.rawCorrect,
      "rawQuestionIDs": data.rawQuestionIDs,
      "rawSelected": data.rawSelected,
      "create_time":DateTime.now().toUtc().microsecondsSinceEpoch
    });

    return affected;
  }

  Future<List<HistoryModel>> getHistoryList() async {
    var db = await DBController().openDB();
    var sql = "SELECT * FROM history WHERE topicId > 0;";
    var data = await db.rawQuery(sql);

    var rs = List<HistoryModel>.generate(
        data.length, (index) => new HistoryModel.fromJSON(data[index]));

    data.forEach((element) {
      log(element.toString());
    });

    return rs;
  }
}
