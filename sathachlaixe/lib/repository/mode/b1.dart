import 'dart:math';

import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/repository/sqlite/historyController.dart';

import 'base.dart';

class B1Mode extends BMode implements BaseMode {
  Map<int, List<String>> _topics = Map.of({
    1: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    2: "2.22.42.62.82.101.122.138.162.210.229.249.267.288.309.329.349.369.389.409.425.449.469.488.508.524.544.564.584.600"
        .split("."),
    3: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    4: "2.22.42.62.82.101.122.138.162.210.229.249.267.288.309.329.349.369.389.409.425.449.469.488.508.524.544.564.584.600"
        .split("."),
    5: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    6: "2.22.42.62.82.101.122.138.162.210.229.249.267.288.309.329.349.369.389.409.425.449.469.488.508.524.544.564.584.600"
        .split("."),
    7: "1.21.41.61.81.102.118.137.161.193.228.247.266.287.308.328.348.368.388.408.428.448.468.487.507.523.543.560.583.599"
        .split("."),
    8: "2.22.42.62.82.101.122.138.162.210.229.249.267.288.309.329.349.369.389.409.425.449.469.488.508.524.544.564.584.600"
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

  B1Mode() : super();

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

    var historyRandTopic = await HistoryController().getLastestHistory(0);
    if (historyRandTopic.isNotEmpty) {
      m[0] = historyRandTopic.first;
    }

    for (int i = 0; i < _topics.keys.length; i++) {
      var key = _topics.keys.elementAt(i);
      var value = _topics.values.elementAt(i);
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
    return countCorrect >= 27;
  }

  @override
  int get length => 30;

  @override
  Duration get duration => Duration(minutes: 20);
}
