import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/repository/sqlite/historyController.dart';

import 'base.dart';

class B1Mode extends BaseMode {
  Map<int, List<String>> topics = Map.of({
    1: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    2: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    3: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    4: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    5: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    6: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    7: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    8: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    9: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    10: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    12: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    13: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    14: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    15: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    16: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    17: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    18: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    19: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
    20: "1.21.41.61.81.102.118.137.161.193.228.247".split("."),
  });

  List<String> criticalQues =
      "17 18 19 20 21 22 23 24 25 26 27 28 29 30 33 35 36 37 40 43 45 46 47 48 49 50 51 52 53 84 91 99 101 109 112 114 118 119 143 145 147 150 152 153 160 199 209 210 211 214 221 227 231 242 245 248 258 260 261 262"
          .split(" ");

  @override
  Future<List<HistoryModel>> getHistoryList() async {
    var data = await HistoryController().getHistoryList();
    Map<int, HistoryModel> m = Map();
    topics.forEach((key, value) {
      // Search for history of topic
      var history = data.where((element) => element.topicID == key);
      if (history.isEmpty) {
        // Add new empty history if not has history yet
        m[key] = HistoryModel.empty(topicID: key);
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
}
