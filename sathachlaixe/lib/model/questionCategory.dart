import 'package:sathachlaixe/singleston/repository.dart';

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

  List<int> getQuestionIds_int() {
    return questionIDs.map((e) => int.parse(e)).toList();
  }

  Future<int> countHasComplete() {
    return repository.countPracticeComplete(this.getQuestionIds_int());
  }
}
