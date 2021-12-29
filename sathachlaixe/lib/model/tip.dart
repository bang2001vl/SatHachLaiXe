class TipModel {
  String title;
  String detail;
  String content;
  String assetURL;
  int typeId;

  List<String> get contentList => content.split('@');
  int get count => contentList.length;
  TipModel(this.title, this.detail, this.content, this.assetURL, this.typeId);
  factory TipModel.fromJSON(Map json) {
    return TipModel(
      json["title"],
      json["detail"],
      json["content"],
      json["assetURL"],
      json["typeId"],
    );
  }
}
