import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/bloc/exampleBloc.dart';
import 'package:sathachlaixe/model/history.dart';

class QuizState {
  late HistoryModel historyModel;
  late List<QuizBaseDB> listQuestion;

  QuizState({required this.historyModel, required this.listQuestion});

  QuizState.empty() {
    historyModel = HistoryModel.empty(topicID: -1);
    listQuestion = List.empty();
  }
}
