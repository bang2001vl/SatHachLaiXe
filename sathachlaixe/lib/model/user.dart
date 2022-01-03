class UserModel {
  String name;
  List<int>? rawimage;
  int latestDelete;
  int updateTime;

  bool get hasImage => rawimage != null && rawimage!.length > 0;

  UserModel({
    required this.name,
    required this.rawimage,
    required this.latestDelete,
    required this.updateTime,
  });

  factory UserModel.fromJSON(json) {
    return UserModel(
      name: json["name"],
      rawimage: json["rawimage"] == null ? null : json["rawimage"].cast<int>(),
      latestDelete: json["latestDelete"],
      updateTime: json["updateTime"],
    );
  }

  Map<String, Object?> toJSON() {
    return Map<String, Object?>.from({
      "name": this.name,
      "rawimage": this.rawimage,
      "latestDelete": this.latestDelete,
      "updateTime": this.latestDelete,
    });
  }
}
