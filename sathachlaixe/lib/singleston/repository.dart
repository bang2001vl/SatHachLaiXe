import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/repository/sqlite/historyController.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';

class RepositoryGL {
  RepositoryGL();

  Future<List<HistoryModel>> getHistory() {
    return AppConfig().mode.getHistoryList();
  }

  HistoryModel getRandomTopic() {
    return AppConfig().mode.randomHistory();
  }

  Future<int> insertHistory(HistoryModel data) {
    return HistoryController().insertHistory(data);
  }
}

final RepositoryGL repository = new RepositoryGL();
