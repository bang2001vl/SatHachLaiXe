import 'package:sathachlaixe/singleston/repository.dart';

class BoardCategoryModel {
  String name;
  String detail;
  List<String> boardIDs;
  String? assetURL;
  String? imageURL;

  int get length => this.boardIDs.length;

  BoardCategoryModel(
      {required this.name,
      required this.detail,
      required this.boardIDs,
      this.assetURL,
      this.imageURL});

  List<int> getBoardIds_int() {
    return boardIDs.map((e) => int.parse(e)).toList();
  }

  Future<int> countHasComplete() {
    return repository.countPracticeComplete(this.getBoardIds_int());
  }
}
