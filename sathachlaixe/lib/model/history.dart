import 'package:sathachlaixe/model/timestamp.dart';

class HistoryModel extends TimeStampModel {
  /// Topic code. Example: topc 1, topic 2,... */
  int topicID = -1;

  /// */
  bool isPassed = false;

  bool isFinished = false;

  Duration timeLeft = Duration.zero;

  /// List of question's d in topic */
  List<String> questionIds = List.empty(growable: true);
  List<String> selectedAns = List.empty(growable: true);
  List<String> correctAns = List.empty(growable: true);

  HistoryModel.empty({required this.topicID}) {
    this.isPassed = false;
  }

  HistoryModel.fromJSON(Map json) {
    this.topicID = json["topicID"];
    this.isPassed = json["isPassed"] == 1;
    this.isFinished = json["isFinished"] == 1;
    this.timeLeft = Duration(seconds: json["timeLeft"]);
    this.rawQuestionIDs = json["rawQuestionIDs"];
    this.rawCorrect = json["rawCorrect"];
    this.rawSelected = json["rawSelected"];

    this.id = json["id"] == null ? null : json["id"];
    this.create_time = json["create_time"] == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(json["create_time"], isUtc: true)
            .toLocal();
    this.sync_time = json["sync_time"] == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(json["sync_time"], isUtc: true)
            .toLocal();
    this.accountID = json["accountID"] == null ? null : json["accountID"];
  }

  Map<String, Object?> toJSON_insert() => {
        "topicID": this.topicID,
        "isPassed": this.isPassed,
        "isFinished": this.isFinished,
        "timeLeft": this.timeLeft,
        "rawCorrect": this.rawCorrect,
        "rawQuestionIDs": this.rawQuestionIDs,
        "rawSelected": this.rawSelected,
      };

  HistoryModel({
    required this.topicID,
    this.isPassed = false,
  }) : super();

  String get rawCorrect {
    return this.correctAns.join('.');
  }

  set rawCorrect(value) {
    this.correctAns = value.split('.');
  }

  get rawSelected {
    return this.selectedAns.join('.');
  }

  set rawSelected(value) {
    this.selectedAns = value.split('.');
  }

  get rawQuestionIDs {
    return this.questionIds.join('.');
  }

  set rawQuestionIDs(value) {
    this.questionIds = value.split('.');
  }

  /** Count number of question in this topic */
  get count {
    return this.questionIds.length;
  }

  countCorrect() {
    var c = 0;
    var a = this.correctAns;
    var b = this.selectedAns;

    if (a.length != b.length) {
      return -1;
    }

    for (var i = 0; i < a.length; i++) {
      if (a[i] == b[i]) {
        c = c + 1;
      }
    }

    return c;
  }

  countWrong() {
    return this.selectedAns.length - this.countCorrect();
  }

  static List<HistoryModel> mockList(length) {
    var rs = List<HistoryModel>.empty(growable: true);
    for (int i = 0; i < length; i++) {
      var temp = new HistoryModel(topicID: i);
      temp.questionIds = List.generate(30, (index) => (index + 1).toString());
      temp.correctAns = List.generate(30, (index) => 1.toString());
      temp.selectedAns = List.generate(30, (index) => (index % 2).toString());
      rs.add(temp);
    }

    return rs;
  }
}
