import 'dart:math';

import 'package:sathachlaixe/model/board.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/model/question.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/repository/sqlite/appController.dart';
import 'package:sathachlaixe/repository/sqlite/boardCategoryController.dart';
import 'package:sathachlaixe/repository/sqlite/boardController.dart';
import 'package:sathachlaixe/repository/sqlite/historyController.dart';
import 'package:sathachlaixe/repository/sqlite/practiceController.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';

class RepositoryGL {
  RepositoryGL();

  String getCurrentMode() {
    return AppConfig().topicType;
  }

  Future<int> updateMode(String mode) {
    return AppController()
        .updateMode(mode)
        .then((value) => AppConfig().notifyModeChange());
  }

  Future<int> getLastSyncTime() async {
    var a = await HistoryController().getMaxSyncTime();
    var b = await PracticeController().getMaxSyncTime();
    return max(a, b);
  }

  Future<List<HistoryModel>> getAllFinishedHistory() {
    return HistoryController().getAllFinishedHistory();
  }

  Future<int> insertHistory(HistoryModel data) {
    return HistoryController().insertHistory(data);
  }

  TopicModel getRandomTopic() {
    return AppConfig().mode.createRandomTopic();
  }

  bool checkPassed(HistoryModel data) {
    return AppConfig().mode.checkResult(data);
  }

  Future<List<HistoryModel>> getLastestHistory(int topicId, {int count = 1}) {
    return HistoryController().getLastestHistory(topicId, count: count);
  }

  Future<List<HistoryModel?>> getLastestHistoryList(List<int> idList) {
    return HistoryController().getLastestHistoryList(idList);
  }

  Future<List<HistoryModel>> getUnsyncHistories() {
    return HistoryController().getUnsyncHistories();
  }

  Future<int> updateSyncTime(
      List<int> historiesIds, List<int> practicesIds, int syncTime) async {
    var a = await HistoryController().updateSyncTime(historiesIds, syncTime);
    var b = await PracticeController().updateSyncTime(practicesIds, syncTime);
    return a + b;
  }

  Duration getTimeLimit() {
    return AppConfig().mode.duration;
  }

  bool checkCritical(int questionId) {
    return AppConfig().mode.checkCritical(questionId);
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

  Future<List<PracticeModel>> getPractice(int questionId) {
    return PracticeController().getPratice(questionId);
  }

  Future<int> insertPractice(PracticeModel data) {
    return PracticeController().insert(data);
  }

  Future<int> insertOrUpdatePractice(
    int questionId,
    int selectedAnswer,
    int correctAnswer, {
    int countWrong = 0,
    int countCorrect = 0,
  }) {
    return PracticeController().insertOrUpdate(
      questionId,
      selectedAnswer,
      correctAnswer,
      countWrong: countWrong,
      countCorrect: countCorrect,
    );
  }

  Future<int> updatePractice(PracticeModel data) {
    return PracticeController().update(data);
  }

  Future<List<PracticeModel>> getUnsyncPractices() {
    return PracticeController().getUnsyncPractices();
  }

  List<TopicModel> getTopoicDemos() {
    return AppConfig().mode.topicDemoList;
  }

  Future<BoardModel?> getBoard(int id) {
    return BoardController().getBoard(id);
  }

  Future<List<BoardModel>> getBoardByCate(int cateId) {
    return BoardController().getBoardByCate(cateId);
  }

  Future<List<BoardCategoryModel>> getBoardCateAll() {
    return BoardCateController().getBoardCateAll();
  }
}

final RepositoryGL repository = new RepositoryGL();
