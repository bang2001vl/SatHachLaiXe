import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathachlaixe/UI/Test/result_screen.dart';
import 'package:sathachlaixe/model/base.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/state/boardFlip.dart';
import 'package:sathachlaixe/state/quiz.dart';

class SelectedIndexEvent extends BlocBaseEvent {
  int selected;
  SelectedIndexEvent(this.selected);
}

class BoardFlipBloc extends Cubit<BoardPlayState> {
  BoardFlipBloc(BoardPlayState initState) : super(initState);

  void selectQuestion(int index) {
    var newState = BoardPlayState.fromInstance(state);
    newState.currentIndex = index;
    emit(newState);
  }

  void selectBoardNext() {
    selectQuestion(state.currentIndex + 1);
  }

  void selectBoardPrevious() {
    selectQuestion(state.currentIndex - 1);
  }

  void changeMode(int mode) {
    var newState = BoardPlayState.fromInstance(state);
    emit(newState);
  }
}
