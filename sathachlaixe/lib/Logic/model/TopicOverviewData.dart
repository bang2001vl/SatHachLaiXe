import 'dart:convert';

import 'package:sathachlaixe/Logic/model/baseAPImodel.dart';

class TopicOverview {
  int id = 1;
  int countCorrect = 28;
  int countWrong = 4;
  double percent = 0.9;
  bool isPassed = true;
  int total = 32;

  TopicOverview({id, countCorrect, countWrong, isPassed}) {
    this.countCorrect = countCorrect;
    this.countWrong = countWrong;
    this.id = id;
    this.isPassed = isPassed;

    this.total = countWrong + countCorrect;
    this.percent = countCorrect / this.total;
  }

  factory TopicOverview.fromJSON(dynamic map) {
    return TopicOverview(
        id: map["id"] as int,
        countCorrect: map["countCorrect"],
        countWrong: map["countWrong"],
        isPassed: map["isPassed"]);
  }
}

class TopicOverViewsResponse extends BaseAPIResponse {
  final List<TopicOverview> list;

  TopicOverViewsResponse(this.list) : super(error: '');
  TopicOverViewsResponse.withError(String error)
      : list = List.empty(),
        super(error: error);

  factory TopicOverViewsResponse.fromJSON(dynamic json) {
    var err = json['error'];
    if (err != null) {
      return TopicOverViewsResponse.withError(err as String);
    }

    final List data = jsonDecode(json['data']);
    final List<TopicOverview> l =
        data.map((topicJSON) => TopicOverview.fromJSON(topicJSON)).toList();

    return TopicOverViewsResponse(l);
  }
}
