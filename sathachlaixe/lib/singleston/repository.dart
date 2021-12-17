import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/repository/mode/b1.dart';
import 'package:sathachlaixe/repository/mode/base.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';

class RepositoryGL {
  final BaseMode mode;
  RepositoryGL({required this.mode});

  Future<List<HistoryModel>> getHistory() {
    //mode.getHistoryList();
    // This is for test-only
    return Future.delayed(
        Duration(seconds: 1), () => HistoryModel.mockList(20));
  }
}

final RepositoryGL repository = new RepositoryGL(mode: B1Mode());
