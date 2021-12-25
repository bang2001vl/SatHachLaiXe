import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/practice.dart';

abstract class SocketObserver {
  void onDataChanged(
      List<HistoryModel> newHistories, List<PracticeModel> newPratices);
}
