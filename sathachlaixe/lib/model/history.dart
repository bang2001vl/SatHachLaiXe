import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/model/timestamp.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/singleston/repository.dart';

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

  HistoryModel.fromTopic(TopicModel topic) {
    this.topicID = topic.topicId;
    this.questionIds = List.from(topic.questionIDs);
    this.selectedAns =
        List.generate(topic.questionIDs.length, (index) => 0.toString());
    this.correctAns =
        List.generate(topic.questionIDs.length, (index) => (-1).toString());
    this.isPassed = false;
    this.isFinished = false;
    this.timeLeft = repository.getTimeLimit();
  }

  HistoryModel.empty({required this.topicID}) {
    this.isPassed = false;
  }

  HistoryModel.copyFrom(HistoryModel other) {
    // It not [yet] copy the timestamp
    this.topicID = other.topicID;
    this.isPassed = other.isPassed;
    this.isFinished = other.isFinished;
    this.timeLeft = other.timeLeft;
    this.questionIds = other.questionIds;
    this.selectedAns = other.selectedAns;
    this.correctAns = other.correctAns;
  }

  HistoryModel.fromJSON(Map json) {
    this.topicID = json["topicID"];
    this.isPassed = json["isPassed"] == 1;
    this.isFinished = json["isFinished"] == 1;
    this.timeLeft = Duration(seconds: json["timeLeft"]);
    this.rawQuestionIDs = json["rawQuestionIDs"];
    this.rawCorrect = json["rawCorrect"];
    this.rawSelected = json["rawSelected"];

    getTimeStamp(json);
  }

  Map<String, Object?> toJSON_insert() => {
        "topicID": this.topicID,
        "isPassed": this.isPassed ? 1 : 0,
        "isFinished": this.isFinished ? 1 : 0,
        "timeLeft": this.timeLeft.inSeconds,
        "rawCorrect": this.rawCorrect,
        "rawQuestionIDs": this.rawQuestionIDs,
        "rawSelected": this.rawSelected,
      };

  Map<String, Object?> toJSON() {
    var json = toJSON_insert();
    json["create_time"] = this.create_time;
    json["update_time"] = this.update_time;
    return json;
  }

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
  int get count {
    return this.questionIds.length;
  }

  bool get hasStarted {
    return this.create_time != null;
  }

  List<int> get questionIds_int {
    return List.generate(
        questionIds.length, (index) => int.parse(questionIds[index]));
  }

  List<int> get selectedAns_int {
    return List.generate(
        selectedAns.length, (index) => int.parse(selectedAns[index]));
  }

  List<int> get correctAns_int {
    return List.generate(
        correctAns.length, (index) => int.parse(correctAns[index]));
  }

  bool isRandomTopic() {
    return topicID == 0;
  }

  int countCorrect() {
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

  int countWrong() {
    return this.selectedAns.length - this.countCorrect();
  }

  int countSelected() {
    return this.selectedAns.where((element) => element != 0.toString()).length;
  }

  Future<List<QuizBaseDB>> getQuizList() async {
    List<QuizBaseDB> quizs = List<QuizBaseDB>.empty(growable: true);
    var db = QuizDB();
    var quizIds = questionIds_int;
    for (int i = 0; i < quizIds.length; i++) {
      quizs.add(await db.findQuizById(quizIds[i]));
    }
    return quizs;
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
