class QuestionCategoryModel {
  String name;
  String detail;
  List<String> questionIDs;
  String? assetURL;
  String? imageURL;

  QuestionCategoryModel(
      {required this.name,
      required this.detail,
      required this.questionIDs,
      this.assetURL,
      this.imageURL});

  Iterable<int> getQuestionIds_int() {
    return questionIDs.map((e) => int.parse(e));
  }
}
