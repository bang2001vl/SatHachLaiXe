import 'package:flutter/material.dart';
import 'package:sathachlaixe/bloc/quizBloc.dart';
import 'package:sathachlaixe/state/quiz.dart';

class PracticeBloc extends QuizBloc {
  PracticeBloc(QuizState initState) : super(initState);

  @override
  void onPressBack(BuildContext context) {
    Navigator.pop(context, 'Cancel');
  }

  @override
  void onPressSubmit(BuildContext context) {
    Navigator.pop(context, 'Cancel');
  }
}
