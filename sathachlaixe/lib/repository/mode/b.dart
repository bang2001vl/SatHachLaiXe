import 'dart:math';

import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/question.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/repository/sqlite/historyController.dart';

class BMode {
  List<String> get criticalQues => rawQuestionCategories.last.questionIDs;

  late List<QuestionCategoryModel> rawQuestionCategories;

  BMode() {
    _initQuestionCategogies();
  }

  bool checkCritical(int questionId) {
    return criticalQues.contains(questionId.toString());
  }

  List<String> getRandomQuesIds() {
    throw UnimplementedError();
  }

  Future<QuestionModel?> getQuestion(int id) {
    return QuizDB().getQuestion(id);
  }

  Future<List<QuestionModel>> getQuestions(List<int> ids) {
    return QuizDB().getQuestionList(ids);
  }

  Future<List<HistoryModel>> getLastestHistory(int topicId, {int count = 1}) {
    return HistoryController().getLastestHistory(topicId, count: count);
  }

  Future<List<HistoryModel>> getLastestHistoryList(List<int> ids) async {
    var rs = List<HistoryModel>.of([]);
    for (int i = 0; i < ids.length; i++) {
      var h = await getLastestHistory(ids[i]);
      if (h.isNotEmpty) {
        rs.add(h.first);
      }
    }
    return rs;
  }

  List<int> getRandomIdFromCategory(
      Random random, QuestionCategoryModel cate, int count, List<int> specs) {
    var rs = List<int>.empty(growable: true);

    specs.forEach((element) {
      if (cate.questionIDs.contains(element.toString())) {
        count--;
      }
      ;
    });

    for (int i = 0; i < count; i++) {
      var id = cate.questionIDs[random.nextInt(cate.questionIDs.length - 1)];
      // prevent duplicate
      while (rs.contains(id)) {
        id = cate.questionIDs[random.nextInt(cate.questionIDs.length - 1)];
      }
      rs.add(int.parse(id));
    }
    return rs;
  }

  HistoryModel randomTopic() {
    var history = HistoryModel.empty(topicID: 0);
    history.questionIds = getRandomQuesIds();
    return history;
  }

  void _initQuestionCategogies() {
    rawQuestionCategories = List.of([
      QuestionCategoryModel(
        name: "Toàn bộ câu hỏi",
        detail: "Tất cả câu hỏi trong bộ đề",
        questionIDs: List.generate(600, (index) => (index + 1).toString()),
        assetURL: "assets/images/question_categotery_all.png",
      ),
      QuestionCategoryModel(
        name: "Khái niệm và quy tắc",
        detail: "Từ câu 1-166 (45 câu điểm liệt)",
        questionIDs: List.generate(166 - 0, (index) => (index + 1).toString()),
        assetURL: "assets/images/question_categotery_1.png",
      ),
      QuestionCategoryModel(
        name: "Nghiệp vụ và vận tải",
        detail: "Từ câu 167-192",
        questionIDs: List.generate(26, (index) => (index + 167).toString()),
        assetURL: "assets/images/question_categotery_2.png",
      ),
      QuestionCategoryModel(
        name: "Văn hóa và đạo đức",
        detail: "Từ câu 193-213 (4 câu điểm liệt)",
        questionIDs: List.generate(21, (index) => (index + 193).toString()),
        assetURL: "assets/images/question_categotery_3.png",
      ),
      QuestionCategoryModel(
        name: "Kỹ thuật lái xe",
        detail: "Từ câu 214-269 (11 câu điểm liệt)",
        questionIDs: List.generate(56, (index) => (index + 214).toString()),
        assetURL: "assets/images/question_categotery_4.png",
      ),
      QuestionCategoryModel(
        name: "Cấu tạo và sửa chữa",
        detail: "Từ câu 270-304",
        questionIDs: List.generate(35, (index) => (index + 270).toString()),
        assetURL: "assets/images/question_categotery_5.png",
      ),
      QuestionCategoryModel(
        name: "Biển báo đường bộ",
        detail: "Từ câu 305-486",
        questionIDs: List.generate(182, (index) => (index + 305).toString()),
        assetURL: "assets/images/question_categotery_6.png",
      ),
      QuestionCategoryModel(
        name: "Sa hình",
        detail: "Từ câu 487-600",
        questionIDs: List.generate(114, (index) => (index + 487).toString()),
        assetURL: "assets/images/question_categotery_7.png",
      ),
      QuestionCategoryModel(
        name: "Câu hỏi điểm liệt",
        detail: "Tổng hợp 60 câu hỏi điểm liệt",
        questionIDs:
            "17 18 19 20 21 22 23 24 25 26 27 28 29 30 33 35 36 37 40 43 45 46 47 48 49 50 51 52 53 84 91 99 101 109 112 114 118 119 143 145 147 150 152 153 160 199 209 210 211 214 221 227 231 242 245 248 258 260 261 262"
                .split(" "),
        assetURL: "assets/images/question_categotery_spec.png",
      ),
    ], growable: false);
  }

  TopicModel createRandomTopic() {
    return TopicModel(topicId: 0, questionIDs: getRandomQuesIds());
  }
}
