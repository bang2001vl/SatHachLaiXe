class AuthModel {
  String email;
  String password;

  AuthModel({
    required this.email,
    required this.password,
  });

  factory AuthModel.fromJSON(json) {
    return AuthModel(
      email: json["email"],
      password: json["password"],
    );
  }

  Map toJSON() {
    return {
      "email": this.email,
      "password": this.password,
    };
  }
}
