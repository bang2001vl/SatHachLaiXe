import 'package:sathachlaixe/model/board.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class BoardCategoryModel {
  int id;
  String name;
  String detail;
  String assetURL;
  String boardIDs;
  List<String> get listBoardIDs => boardIDs.split(' ');
  BoardCategoryModel(
      this.id, this.name, this.detail, this.assetURL, this.boardIDs);

  factory BoardCategoryModel.fromJSON(Map json) {
    return BoardCategoryModel(
      json['id'],
      json['name'],
      json['detail'],
      json['assetURL'],
      json['boardIDs'],
    );
  }

  Future<List<int>> getChilds_Ids() async {
    var a = await getChilds();
    return List.generate(a.length, (index) => a[index].id).toList();
  }

  Future<List<BoardModel>> getChilds() {
    return repository.getBoardByCate(this.id);
  }

  List<int> getBoardIds_int() {
    return listBoardIDs.map((e) => int.parse(e)).toList();
  }
}
