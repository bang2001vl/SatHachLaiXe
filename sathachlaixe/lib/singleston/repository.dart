import 'dart:async';
import 'dart:developer';

import 'package:sathachlaixe/model/board.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/model/question.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/model/tip.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/model/user.dart';
import 'package:sathachlaixe/repository/auth.dart';
import 'package:sathachlaixe/repository/sqlite/appController.dart';
import 'package:sathachlaixe/repository/sqlite/boardCategoryController.dart';
import 'package:sathachlaixe/repository/sqlite/boardController.dart';
import 'package:sathachlaixe/repository/sqlite/historyController.dart';
import 'package:sathachlaixe/repository/sqlite/practiceController.dart';
import 'package:sathachlaixe/repository/sqlite/tipController.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/socketio.dart';

final RepositoryGL repository = new RepositoryGL();

class RepositoryGL {
  RepositoryGL();

  static const serverURL = "http://thunderv.southeastasia.cloudapp.azure.com";

  String getCurrentMode() {
    return AppConfig().topicType;
  }

  Future<int> updateMode(String mode) {
    return AppConfig.instance
        .saveMode(mode)
        .then((value) => AppConfig().notifyModeChange());
  }

  bool get isSyncON => AppConfig.instance.syncState == 1;
  bool get isAuthorized => SocketController.instance.isConnected;

  Future<void> updateSyncState(int? state) async {
    AppConfig.instance.syncState = state;
    await AppConfig.instance.saveSycnState(state);
    if (isSyncON) {
      SocketController.instance.notifyDataChanged();
    }
  }

  Future<void> updateToken(String? token) async {
    AppConfig.instance.token = token;
    await AppConfig.instance.saveToken(token);
  }

  Future<void> updateLatestSyncTime(int unixTimeStamp) async {
    log("AppConfig: Update syncTime = " + unixTimeStamp.toString());
    AppConfig.instance.latestSyncTime = unixTimeStamp;
    await AppConfig.instance.saveLatestSyncTime(unixTimeStamp);
  }

  Future<void> updateUserInfo(UserModel? userInfo) async {
    AppConfig.instance.userInfo = userInfo;
    await AppConfig.instance.saveUserInfo(userInfo);
  }

  FutureOr<int> getLastSyncTime() async {
    // var a = await HistoryController().getMaxSyncTime();
    // var b = await PracticeController().getMaxSyncTime();
    // return max(a, b);
    return AppConfig.instance.latestSyncTime;
  }

  Future<List<HistoryModel>> getAllFinishedHistory() {
    return HistoryController().getAllFinishedHistory();
  }

  Future<int> insertHistory(HistoryModel data) async {
    var c = await HistoryController().insertHistory(data);
    if (isSyncON) {
      SocketController.instance.notifyDataChanged();
    }
    return c;
  }

  TopicModel getRandomTopic() {
    return AppConfig().mode.createRandomTopic();
  }

  bool checkPassed(HistoryModel data) {
    return AppConfig().mode.checkResult(data);
  }

  Future<List<HistoryModel>> getAllHistory() {
    return HistoryController().getAll();
  }

  Future<List<PracticeModel>> getAllpractice() {
    return PracticeController().getAll();
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
      List<HistoryModel> histories, List<PracticeModel> practices) async {
    var a = await HistoryController().updateSyncTimeAll(histories);
    var b = await PracticeController().updateSyncTimeAll(practices);
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

  Future<int> insertOrUpdatePracticeAnswer(PracticeModel model) async {
    var c = await PracticeController().insertOrUpdateAnswer(model);

    if (isSyncON) {
      SocketController.instance.notifyDataChanged();
    }

    return c;
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

  Future<List<TipModel>> getTipsByType(int typeId) {
    return TipController().getTipByType(typeId);
  }

  Future<int> deleteAllData() async {
    var count = 0;
    count += await HistoryController().deleteAll();
    count += await PracticeController().deleteAll();
    return count;
  }

  Future<int> deleteAllDataUntil(int maxTime) async {
    var count = 0;
    count += await HistoryController().deleteAllUntil(maxTime);
    count += await PracticeController().deleteAllUntil(maxTime);
    return count;
  }

  TipRepo tips = TipController();
  AuthRepo auth = AuthController();
}

abstract class TipRepo {
  Future<List<TipModel>> getTipAll();
  Future<List<TipModel>> getTipByType(int typeId);
}
