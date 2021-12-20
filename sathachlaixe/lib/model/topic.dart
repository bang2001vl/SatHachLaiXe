class TopicModel {
  int topicId;
  List<String> questionIDs;
  TopicModel({
    required this.topicId,
    required this.questionIDs,
  });

  bool get isRandom => topicId == 0;

  Iterable<int> getQuestionIds_int() {
    return questionIDs.map((e) => int.parse(e));
  }
}
