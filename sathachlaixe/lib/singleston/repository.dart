import 'package:sathachlaixe/model/board.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/model/question.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/repository/sqlite/appController.dart';
import 'package:sathachlaixe/repository/sqlite/boardCategoryController.dart';
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
      int questionId, int selectedAnswer, int correctAnswer) {
    return PracticeController()
        .insertOrUpdate(questionId, selectedAnswer, correctAnswer);
  }

  Future<int> updatePractice(PracticeModel data) {
    return PracticeController().update(data);
  }

  List<TopicModel> getTopoicDemos() {
    return AppConfig().mode.topicDemoList;
  }

  Future<BoardModel> getBoard(int id) {
    return Future.value(BoardModel.empty(
      id: 1,
      cateId: 1,
      name: "Biển báo 1",
      detail: "Biển cấm hình tròn, nền trắng, viền đỏ, hình vẽ màu đen.",
      assetURL: "assets/images/question_categotery_all.png",
    ));
  }

  Future<List<BoardCategoryModel>> getBoardCategory() {
    return BoardCateController().getBoardCateAll();
    // test only
    return Future.value(List.from([
      BoardCategoryModel.empty(
        id: 1,
        name: "Biển báo cấm",
        detail: "Biển cấm hình tròn, nền trắng, viền đỏ, hình vẽ màu đen.",
        assetURL: "assets/images/biencam.jpg",
      ),
      BoardCategoryModel.empty(
        id: 2,
        name: "Biển hiệu lệnh",
        detail: "Có dạng hình tròn, nền xanh, hình vẽ màu trắng.",
        assetURL: "assets/images/bienhieulenh.jpg",
      ),
      BoardCategoryModel.empty(
        id: 3,
        name: "Biển chỉ dẫn",
        detail:
            "Có dạng hình vuông hoặc hình chữ nhật, nền xanh, hình vẽ màu trắng.",
        assetURL: "assets/images/bienchidan.png",
      ),
      BoardCategoryModel.empty(
        id: 4,
        name: "Biển báo nguy hiểm và cảnh báo",
        detail:
            "Có dạng hình tam giác đều, viền đỏ, nền vàng, hình vẽ màu đen.",
        assetURL: "assets/images/biennguyhiem.png",
      ),
      BoardCategoryModel.empty(
        id: 5,
        name: "Biển phụ",
        detail:
            "Có hình chữ nhật đứng hoặc ngang, nền trắng, viền đen, hình vẽ màu đen, thường đặt dưới biển báo chính.",
        assetURL: "assets/images/bienphu.jpg",
      ),
    ]));
  }
}

final RepositoryGL repository = new RepositoryGL();
