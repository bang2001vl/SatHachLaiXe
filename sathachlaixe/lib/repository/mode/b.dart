import 'dart:math';

import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/question.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/model/topic.dart';

class BMode {
  List<String> criticalQues =
      "17 18 19 20 21 22 23 24 25 26 27 28 29 30 33 35 36 37 40 43 45 46 47 48 49 50 51 52 53 84 91 99 101 109 112 114 118 119 143 145 147 150 152 153 160 199 209 210 211 214 221 227 231 242 245 248 258 260 261 262"
          .split(" ");

  late List<QuestionCategoryModel> _questionCategories;
  List<QuestionCategoryModel> get questionCategoryList => _questionCategories;

  BMode() {
    _initQuestionCategogies();

    questionCategoryList.forEach((it) {
      it.questionIDs.removeWhere((element) => criticalQues.contains(element));
    });
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
    _questionCategories = List.of([
      QuestionCategoryModel(
        name: "Toàn bộ câu hỏi",
        detail: "Tất cả câu hỏi trong bộ đề",
        questionIDs: List.generate(600, (index) => (index + 1).toString()),
      ),
      QuestionCategoryModel(
        name: "Câu hỏi điểm liệt",
        detail: "Tổng hợp 60 câu hỏi điểm liệt",
        questionIDs:
            "17 18 19 20 21 22 23 24 25 26 27 28 29 30 33 35 36 37 40 43 45 46 47 48 49 50 51 52 53 84 91 99 101 109 112 114 118 119 143 145 147 150 152 153 160 199 209 210 211 214 221 227 231 242 245 248 258 260 261 262"
                .split(" "),
      ),
      QuestionCategoryModel(
        name: "Khái niệm và quy tắc",
        detail: "Từ câu 1-166 (45 câu điểm liệt)",
        questionIDs: List.generate(166 - 0, (index) => (index + 1).toString()),
      ),
      QuestionCategoryModel(
        name: "Nghiệp vụ và vận tải",
        detail: "Từ câu 167-192",
        questionIDs: List.generate(26, (index) => (index + 167).toString()),
      ),
      QuestionCategoryModel(
        name: "Văn hóa và đạo đức",
        detail: "Từ câu 193-213 (4 câu điểm liệt)",
        questionIDs: List.generate(21, (index) => (index + 193).toString()),
      ),
      QuestionCategoryModel(
        name: "Kỹ thuật lái xe",
        detail: "Từ câu 214-269 (11 câu điểm liệt)",
        questionIDs: List.generate(56, (index) => (index + 214).toString()),
      ),
      QuestionCategoryModel(
        name: "Cấu tạo và sửa chữa",
        detail: "Từ câu 270-304",
        questionIDs: List.generate(35, (index) => (index + 270).toString()),
      ),
      QuestionCategoryModel(
        name: "Biển báo đường bộ",
        detail: "Từ câu 305-486",
        questionIDs: List.generate(182, (index) => (index + 305).toString()),
      ),
      QuestionCategoryModel(
        name: "Sa hình",
        detail: "Từ câu 487-600",
        questionIDs: List.generate(114, (index) => (index + 487).toString()),
      ),
    ], growable: false);
  }

  TopicModel createRandomTopic() {
    return TopicModel(id: 0, questionIDs: getRandomQuesIds());
  }
}
