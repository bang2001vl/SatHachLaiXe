import 'dart:math';

import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/repository/mode/b.dart';
import 'package:sathachlaixe/repository/sqlite/historyController.dart';

import 'base.dart';

class B2Mode extends BMode implements BaseMode {
  late List<TopicModel> _topics;

  B2Mode() : super() {
    _initDemoTopic();
  }

  @override
  List<QuestionCategoryModel> get questionCategoryList => rawQuestionCategories;

  @override
  int get length => 35;

  @override
  Duration get duration => Duration(minutes: 20);

  @override
  List<TopicModel> get topicDemoList => _topics;

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
  Future<List<HistoryModel>> getHistoryList() async {
    Map<int, HistoryModel> m = Map();

    var historyRandTopic = await HistoryController().getLastestHistory(0);
    if (historyRandTopic.isNotEmpty) {
      m[0] = historyRandTopic.first;
    }

    for (int i = 0; i < _topics.length; i++) {
      var key = _topics.elementAt(i).topicId;
      var value = _topics.elementAt(i).questionIDs;
      var history = await HistoryController().getLastestHistory(key);
      if (history.isEmpty) {
        // Add new empty history if not has history yet
        m[key] = HistoryModel.empty(topicID: key);
        m[key]?.questionIds = value;
      } else {
        // Get history if already has one
        m[key] = history.first;
      }
    }

    return m.values.toList();
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
    return countCorrect >= 32;
  }

  void _initDemoTopic() {
    _topics = List.empty(growable: true);
    _topics.add(TopicModel(
        topicId: 1,
        questionIDs:
            "1.21.41.45.61.81.102.118.137.161.193.200.228.247.266.287.308.309.328.348.368.380.388.408.428.448.468.487.507.523.530.543.560.583.599"
                .split(".")));
    _topics.add(TopicModel(
        topicId: 2,
        questionIDs:
            "2.22.42.62.70.82.101.122.138.162.163.210.229.249.267.270.288.309.329.349.352.369.389.409.425.449.469.488.508.524.544.550.564.584.600"
                .split(".")));
  }
}
