import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathachlaixe/UI/Test/result_screen.dart';
import 'package:sathachlaixe/model/base.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/state/quiz.dart';

class SelectedIndexEvent extends BlocBaseEvent {
  int selected;
  SelectedIndexEvent(this.selected);
}

class QuizBloc extends Cubit<QuizState> {
  QuizBloc(QuizState initState) : super(initState);
  Timer? _timer;

  void selectAnswer(int select, int correct) {
    var newState = QuizState.fromInstance(state);
    newState.selectAnswer(select, correct);
    emit(newState);
  }

  void selectQuestion(int index) {
    var newState = QuizState.fromInstance(state);
    newState.currentIndex = index;
    emit(newState);
  }

  void selectQuestionNext() {
    selectQuestion(state.currentIndex + 1);
  }

  void selectQuestionPrevious() {
    selectQuestion(state.currentIndex - 1);
  }

  void changeMode(int mode) {
    var newState = QuizState.fromInstance(state);
    newState.mode = mode;
    emit(newState);
  }

  void startTimer() {
    if (state.mode == 1 || _timer != null) {
      // Do nothing
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        // if (await this.isClosed) {
        //   return;
        // }
        var newState = QuizState.fromInstance(state);
        newState.timeLeft -= Duration(seconds: 1);
        emit(newState);
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void onPressBack(BuildContext context) {
    if (state.mode == 1 || state.isFinished) {
      Navigator.pop(context, 'Cancel');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Tạm dừng"),
          content: const Text("Bạn có muốn tạm dừng để tiếp tục lần tới?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Ok'),
              child: const Text('Có'),
            ),
          ],
        ),
      ).then((value) {
        if (value == "Ok") {
          onPressPause(context);
        } else if (value == "Cancel") {
          Navigator.pop(context, 'Cancel');
        }
      });
    }
  }

  void onPressPause(BuildContext context) {
    saveHistory(false);
    Navigator.pop(context, 'Pause');
  }

  void onPressSubmit(BuildContext context) {
    stopTimer();
    if (state.selectedList.contains("0")) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Chưa hoàn tất"),
          content:
              const Text("Vẫn còn câu để trống. Bạn chắc chắn muốn nộp bài?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Ok'),
              child: const Text('Có'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Không'),
            ),
          ],
        ),
      ).then((value) {
        if (value == "Ok") {
          submit(context);
        } else {
          startTimer();
        }
      });
    } else {
      BlocProvider.of<QuizBloc>(context).submit(context);
    }
  }

  void submit(BuildContext context) {
    var history = saveHistory(true);
    var resultView = ResultTest(
      history: history,
    );
    Navigator.push(context, MaterialPageRoute(builder: (_) => resultView))
        .then((value) {
      if (value == ResultTest.RESULT_CANCEL) {
        Navigator.pop(context, "Review");
      } else if (value == ResultTest.RESULT_REVIEW) {
        changeMode(1);
      }
    });
  }

  HistoryModel saveHistory(bool isFinished) {
    var history = HistoryModel.fromTopic(state.tag as TopicModel);
    history.isFinished = isFinished;
    history.timeLeft = state.timeLeft;
    history.selectedAns = List.from(state.selectedList);
    history.correctAns = List.from(state.correctList);
    if (history.isFinished) {
      history.isPassed = repository.checkPassed(history);
    }

    repository.insertHistory(history);

    return history;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
