import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/repository/sqlite/practiceController.dart';

class StatisticRepo {
  Future<int> getCountWrong(int questionId) async {
    var p = await PracticeController().getPratice(questionId);
    if (p.isEmpty) {
      return 0;
    } else {
      return p.first.countWrong;
    }
  }

  Future<PracticeModel?> getPractice(int questionId) async {
    var p = await PracticeController().getPratice(questionId);
    if (p.isEmpty) {
      return null;
    } else {
      return p.first;
    }
  }
}
