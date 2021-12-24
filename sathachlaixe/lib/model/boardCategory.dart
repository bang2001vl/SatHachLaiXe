import 'package:sathachlaixe/model/board.dart';

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

  Future<List<BoardModel>> getChilds_Ids() {
    // test only
    return Future.value(List.from([
      1,
      2,
    ]));
  }

  Future<List<BoardModel>> getChilds() {
    // test only
    return Future.value(List.from([
      BoardModel.empty(
        id: 1,
        cateId: this.id,
        name: "Biển báo 1",
        detail: "Biển cấm hình tròn, nền trắng, viền đỏ, hình vẽ màu đen.",
        assetURL: "assets/images/question_categotery_all.png",
      ),
      BoardModel.empty(
        id: 2,
        cateId: this.id,
        name: "Biển hiệu 2",
        detail: "Có dạng hình tròn, nền xanh, hình vẽ màu trắng.",
        assetURL: "assets/images/question_categotery_1.png",
      )
    ]));
  }
}
