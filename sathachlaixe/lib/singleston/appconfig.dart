class AppConfig {
  String topicType = "b1";

  AppConfig._privateConstructor() {}

  static final AppConfig _instance = AppConfig._privateConstructor();

  factory AppConfig() {
    return _instance;
  }
}
