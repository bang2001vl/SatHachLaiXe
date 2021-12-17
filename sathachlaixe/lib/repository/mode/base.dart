import 'package:sathachlaixe/model/history.dart';

abstract class BaseMode {
  int get length;
  bool checkResult(HistoryModel data);
  Future<List<HistoryModel>> getHistoryList();
}
