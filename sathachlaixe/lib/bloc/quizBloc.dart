import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathachlaixe/model/base.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/state/quiz.dart';

class SelectedIndexEvent extends BlocBaseEvent {
  int selected;
  SelectedIndexEvent(this.selected);
}

class QuizBloc extends Cubit<QuizState> {
  QuizBloc(QuizState initState) : super(initState);
  Timer? _timer;

  void selectAnswer(int select, int correct) {
    var newState = QuizState(
      mode: state.mode,
      history: HistoryModel.copyFrom(state.history),
      topic: state.topic,
      currentIndex: state.currentIndex,
    );
    newState.selectAnswer(select, correct);
    emit(newState);
  }

  void selectQuestion(int index) {
    emit(QuizState(
        mode: state.mode,
        history: state.history,
        topic: state.topic,
        currentIndex: index));
  }

  void selectQuestionNext() {
    selectQuestion(state.currentIndex + 1);
  }

  void selectQuestionPrevious() {
    selectQuestion(state.currentIndex - 1);
  }

  void changeMode(int mode) {
    emit(QuizState(
      mode: mode,
      history: state.history,
      topic: state.topic,
      currentIndex: state.currentIndex,
    ));
  }

  void begin() {
    if (state.mode == 1) {
      // Do nothing
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        var his = HistoryModel.copyFrom(state.history);
        his.timeLeft -= Duration(seconds: 1);
        emit(QuizState(
          mode: state.mode,
          history: his,
          topic: state.topic,
          currentIndex: state.currentIndex,
        ));
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
