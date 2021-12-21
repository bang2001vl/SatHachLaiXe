import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/question.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/repository/sqlite/historyController.dart';
import 'package:sathachlaixe/repository/sqlite/practiceController.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';

class RepositoryGL {
  RepositoryGL();

  Future<List<HistoryModel>> getAllFinishedHistory() {
    return HistoryController().getAllFinishedHistory();
  }

  TopicModel getRandomTopic() {
    return AppConfig().mode.createRandomTopic();
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

  Future<QuestionModel?> getQuestion(int id) {
    return AppConfig().mode.getQuestion(id);
  }

  Future<List<QuestionModel>> getQuestions(List<int> ids) {
    return AppConfig().mode.getQuestions(ids);
  }

  List<QuestionCategoryModel> getQuestionCategory() {
    return AppConfig().mode.questionCategoryList;
  }

  Future<int> countPracticeComplete(List<int> questionIds) {
    return PracticeController().countHasPraticed(questionIds);
  }

  Future<List<HistoryModel>> getLastestHistory(int topicId, {int count = 1}) {
    return HistoryController().getLastestHistory(topicId, count: count);
  }

  Future<List<HistoryModel?>> getLastestHistoryList(List<int> idList) {
    return HistoryController().getLastestHistoryList(idList);
  }

  List<TopicModel> getTopoicDemos() {
    return AppConfig().mode.topicDemoList;
  }
}

final RepositoryGL repository = new RepositoryGL();
