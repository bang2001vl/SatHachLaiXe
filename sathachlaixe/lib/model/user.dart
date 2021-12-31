class UserModel {
  String name;
  String? image;
  int latestDelete;
  int updateTime;

  UserModel({
    required this.name,
    required this.image,
    required this.latestDelete,
    required this.updateTime,
  });

  factory UserModel.fromJSON(json) {
    return UserModel(
      name: json["name"],
      image: json["image"],
      latestDelete: json["latestDelete"],
      updateTime: json["updateTime"],
    );
  }

  Map<String, Object?> toJSON() {
    return Map<String, Object?>.from({
      "name": this.name,
      "image": this.image,
      "latestDelete": this.latestDelete,
      "updateTime": this.latestDelete,
    });
  }
}
