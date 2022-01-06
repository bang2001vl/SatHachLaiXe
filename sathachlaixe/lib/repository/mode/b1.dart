import 'dart:math';

import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/repository/mode/b.dart';

class B1Mode extends BMode {
  late List<TopicModel> _topics;
  List<TopicModel> get topicDemoList => _topics;

  B1Mode() : super() {
    _initDemoTopic();
  }

  @override
  List<QuestionCategoryModel> get questionCategoryList {
    var rs = List<QuestionCategoryModel>.from(rawQuestionCategories);
    var topic2 = rs[2];
    rs[0]
        .questionIDs
        .removeWhere((element) => topic2.questionIDs.contains(element));
    rs.remove(topic2);
    return rs;
  }

  @override
  List<String> getRandomQuesIds() {
    Random ran = Random(DateTime.now().microsecondsSinceEpoch);
    var cateList = rawQuestionCategories;

    var specs = List.generate(2,
        (i) => int.parse(criticalQues[ran.nextInt(criticalQues.length - 1)]));

    var c1 = getRandomIdFromCategory(ran, cateList[1], 8, specs);
    c1.addAll(getRandomIdFromCategory(ran, cateList[3], 1, specs));
    c1.addAll(getRandomIdFromCategory(ran, cateList[4], 2, specs));
    c1.addAll(getRandomIdFromCategory(ran, cateList[5], 1, specs));
    c1.addAll(getRandomIdFromCategory(ran, cateList[6], 9, specs));
    c1.addAll(getRandomIdFromCategory(ran, cateList[7], 9, specs));
    c1.addAll(specs);

    c1.sort();
    return List.from(c1.map((e) => e.toString()));
  }

  @override
  HistoryModel randomTopic() {
    var history = HistoryModel.empty(topicID: 0);
    history.questionIds = getRandomQuesIds();
    return history;
  }

  @override
  bool checkResult(HistoryModel data) {
    for (int index = 0; index < data.questionIds.length; index++) {
      if (data.selectedAns[index] != data.correctAns[index]) {
        // Check critical when it is wrong
        if (criticalQues.contains(data.questionIds[index])) {
          // Failed when wrong critical question
          return false;
        }
      }
    }

    int countCorrect = data.countCorrect();
    return countCorrect >= 27;
  }

  @override
  int get length => 30;

  @override
  Duration get duration => Duration(minutes: 20);

  void _initDemoTopic() {
    _topics = List.of([
      TopicModel(
          topicId: 1,
          questionIDs:
              "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
                  .split("."),
          timeLimit: this.duration),
      TopicModel(
          topicId: 2,
          questionIDs:
              "2.22.42.62.82.101.122.138.162.210.229.249.267.288.309.329.349.369.389.409.425.449.469.488.508.524.544.564.584.600"
                  .split("."),
          timeLimit: this.duration),
    ]);
  }
}
