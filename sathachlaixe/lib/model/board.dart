class BoardModel {
  int id;
  int cateId;
  String name;
  String detail;
  String assetURL;

  BoardModel(this.id, this.cateId, this.name, this.detail, this.assetURL);

  BoardModel.empty({
    this.id = -1,
    this.cateId = -1,
    this.name = '',
    this.detail = '',
    this.assetURL = '',
  });

  factory BoardModel.fromJSON(Map json) {
    return BoardModel(
      json['id'],
      json['cateId'],
      json['name'],
      json['detail'],
      json['assetURL'],
    );
  }
}
