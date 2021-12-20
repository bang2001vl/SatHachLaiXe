import 'dart:math';

import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/repository/sqlite/historyController.dart';

abstract class BaseMode {
  int get length;
  Duration get duration;

  bool checkResult(HistoryModel data);
  Future<List<HistoryModel>> getHistoryList();
  HistoryModel randomHistory();
}

class TopicRange {
  int min;
  int max;
  List<int> rangeNotCris;
  TopicRange(
      {required this.min, required this.max, required this.rangeNotCris});
}

class BMode {
  List<String> criticalQues =
      "17 18 19 20 21 22 23 24 25 26 27 28 29 30 33 35 36 37 40 43 45 46 47 48 49 50 51 52 53 84 91 99 101 109 112 114 118 119 143 145 147 150 152 153 160 199 209 210 211 214 221 227 231 242 245 248 258 260 261 262"
          .split(" ");
  Map<int, TopicRange> topicsList = Map.identity();
  BMode() {
    Map<int, List<int>> questionMap = {
      1: List.generate(166, (index) => index + 1),
      2: List.generate(26, (index) => index + 167),
      3: List.generate(21, (index) => index + 193),
      4: List.generate(56, (index) => index + 214),
      5: List.generate(35, (index) => index + 270),
      6: List.generate(182, (index) => index + 305),
      7: List.generate(114, (index) => index + 487),
    };

    questionMap.forEach((key, value) {
      value.sort();
      value.removeWhere((element) => criticalQues.contains(element.toString()));
    });

    topicsList = {
      1: TopicRange(min: 1, max: 166, rangeNotCris: questionMap[1]!),
      2: TopicRange(min: 167, max: 192, rangeNotCris: questionMap[2]!),
      3: TopicRange(min: 193, max: 213, rangeNotCris: questionMap[3]!),
      4: TopicRange(min: 214, max: 269, rangeNotCris: questionMap[4]!),
      5: TopicRange(min: 270, max: 304, rangeNotCris: questionMap[5]!),
      6: TopicRange(min: 305, max: 486, rangeNotCris: questionMap[6]!),
      7: TopicRange(min: 487, max: 600, rangeNotCris: questionMap[7]!),
    };
  }

  List<int> getRandFromRange(
      Random ran, TopicRange range, int count, List<int> specs) {
    var rs = List<int>.empty(growable: true);
    specs.forEach((element) {
      if (element >= range.min && element <= range.max) {
        count--;
        rs.add(element);
      }
    });
    for (int i = 0; i < count; i++) {
      var a = range.rangeNotCris[ran.nextInt(range.rangeNotCris.length - 1)];
      // prevent duplicate
      while (rs.contains(a)) {
        a = range.rangeNotCris[ran.nextInt(range.rangeNotCris.length - 1)];
      }
      rs.add(a);
    }
    return rs;
  }
}
