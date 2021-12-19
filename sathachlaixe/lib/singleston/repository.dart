import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/repository/sqlite/historyController.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';

class RepositoryGL {
  RepositoryGL();

  Future<List<HistoryModel>> getHistory() {
    return AppConfig().mode.getHistoryList();
  }

  Future<List<HistoryModel>> getAllFinishedHistory() {
    return HistoryController().getAllFinishedHistory();
  }

  HistoryModel getRandomTopic() {
    return AppConfig().mode.randomTopic();
  }

  Future<int> insertHistory(HistoryModel data) {
    return HistoryController().insertHistory(data);
  }

  bool checkPassed(HistoryModel data) {
    return AppConfig().mode.checkResult(data);
  }

  Duration getTimeLimit() {
    return AppConfig().mode.duration;
  }
}

final RepositoryGL repository = new RepositoryGL();
