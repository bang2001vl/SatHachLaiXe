import 'package:flutter/material.dart';
import 'package:sathachlaixe/bloc/quizBloc.dart';
import 'package:sathachlaixe/state/quiz.dart';

class PracticeBloc extends QuizBloc {
  PracticeBloc(QuizState initState) : super(initState);

  @override
  Future<bool> onPressBack(BuildContext context) async {
    Navigator.pop(context, 'Cancel');
    return true;
  }

  @override
  void onPressSubmit(BuildContext context) {
    Navigator.pop(context, 'Cancel');
  }
}
