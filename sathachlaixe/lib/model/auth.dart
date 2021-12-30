class AuthModel {
  String email;
  String password;
  AuthModel({
    required this.email,
    required this.password,
  });
  Map toJSON() {
    return {
      "email": this.email,
      "password": this.password,
    };
  }
}
