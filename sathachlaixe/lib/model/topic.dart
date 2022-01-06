class TopicModel {
  int topicId;
  List<String> questionIDs;
  Duration timeLimit;
  TopicModel({
    required this.topicId,
    required this.questionIDs,
    required this.timeLimit,
  });

  bool get isRandom => topicId == 0;

  Iterable<int> getQuestionIds_int() {
    return questionIDs.map((e) => int.parse(e));
  }
}
