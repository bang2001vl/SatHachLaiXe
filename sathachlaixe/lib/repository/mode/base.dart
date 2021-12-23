import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/question.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/model/topic.dart';

abstract class BaseMode {
  int get length;
  Duration get duration;

  List<TopicModel> get topicDemoList;
  TopicModel createRandomTopic();

  bool checkCritical(int questionId);

  bool checkResult(HistoryModel data);

  List<QuestionCategoryModel> get questionCategoryList;

  Future<QuestionModel?> getQuestion(int id);
  Future<List<QuestionModel>> getQuestions(List<int> ids);
}

class TopicRange {
  int min;
  int max;
  List<int> rangeNotCris;
  TopicRange(
      {required this.min, required this.max, required this.rangeNotCris});
}
