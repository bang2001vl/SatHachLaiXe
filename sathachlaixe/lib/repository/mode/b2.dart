import 'dart:math';

import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/repository/sqlite/historyController.dart';

import 'base.dart';

class B2Mode extends BMode implements BaseMode {
  Map<int, List<String>> _topics = Map.of({
    1: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    2: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    3: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    4: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    5: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    6: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    7: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    8: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    9: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    10: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    12: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    13: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    14: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    15: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    16: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    17: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    18: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    19: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    20: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
  });

  B2Mode() : super();

  List<String> getRandom() {
    Random ran = Random(DateTime.now().microsecondsSinceEpoch);

    var specs = List.generate(2,
        (i) => int.parse(criticalQues[ran.nextInt(criticalQues.length - 1)]));

    var c1 = getRandFromRange(ran, topicsList[1]!, 8, specs);
    c1.addAll(getRandFromRange(ran, topicsList[3]!, 1, specs));
    c1.addAll(getRandFromRange(ran, topicsList[4]!, 2, specs));
    c1.addAll(getRandFromRange(ran, topicsList[5]!, 1, specs));
    c1.addAll(getRandFromRange(ran, topicsList[6]!, 9, specs));
    c1.addAll(getRandFromRange(ran, topicsList[7]!, 9, specs));

    c1.sort();
    return List.from(c1.map((e) => e.toString()));
  }

  @override
  HistoryModel randomHistory() {
    var history = HistoryModel.empty(topicID: 0);
    history.questionIds = getRandom();
    return history;
  }

  @override
  Future<List<HistoryModel>> getHistoryList() async {
    Map<int, HistoryModel> m = Map();
    for (int i = 0; i < _topics.length; i++) {}
    _topics.forEach((key, value) async {
      // Search for history of topic
      var history = await HistoryController().getLastestHistory(key);
      if (history.isEmpty) {
        // Add new empty history if not has history yet
        m[key] = HistoryModel.empty(topicID: key);
        m[key]?.questionIds = value;
      } else {
        // Get history if already has one
        m[key] = history.first;
      }
    });

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
    return countCorrect >= 27;
  }

  @override
  int get length => 35;

  @override
  Duration get duration => Duration(minutes: 20);
}
