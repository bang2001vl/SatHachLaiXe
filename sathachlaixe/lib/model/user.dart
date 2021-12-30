class UserModel {
  String name;

  UserModel({
    required this.name,
  });

  factory UserModel.fromJSON(json) {
    return UserModel(
      name: json["name"],
    );
  }

  Map<String, Object?> toJSON() {
    return Map<String, Object?>.from({
      "name": this.name,
    });
  }
}
