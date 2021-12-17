import 'package:sathachlaixe/model/history.dart';

class RepositoryGL {
  // RepositoryGL._privateConstructor() {}

  // static final RepositoryGL _instance = RepositoryGL._privateConstructor();

  // static RepositoryGL get instance => _instance;

  Future<List<HistoryModel>> getHistory() {
    // This is for test-only
    return Future.delayed(
        Duration(seconds: 1), () => HistoryModel.mockList(20));
  }
}

final RepositoryGL repository = new RepositoryGL();
