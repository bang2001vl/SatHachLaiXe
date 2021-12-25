import 'package:sathachlaixe/model/board.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class BoardCategoryModel {
  int id;
  String name;
  String detail;
  String assetURL;

  BoardCategoryModel(this.id, this.name, this.detail, this.assetURL);

  BoardCategoryModel.empty({
    this.id = -1,
    this.name = '',
    this.detail = '',
    this.assetURL = '',
  });

  factory BoardCategoryModel.fromJSON(Map json) {
    return BoardCategoryModel(
      json['id'],
      json['name'],
      json['detail'],
      json['assetURL'],
    );
  }

  Future<List<int>> getChilds_Ids() async {
    var a = await getChilds();
    return List.generate(a.length, (index) => a[index].id).toList();
  }

  Future<List<BoardModel>> getChilds() {
    return repository.getBoardByCate(this.id);
  }
}
