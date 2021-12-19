class TopicModel {
  int id;
  List<String> questionIDs;
  TopicModel({
    required this.id,
    required this.questionIDs,
  });

  Iterable<int> getQuestionIds_int() {
    return questionIDs.map((e) => int.parse(e));
  }
}
