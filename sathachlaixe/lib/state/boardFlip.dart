import 'package:flutter/material.dart';
import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/UI/Component/board_category.dart';
import 'package:sathachlaixe/bloc/exampleBloc.dart';
import 'package:sathachlaixe/model/board.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class BoardPlayState {
  String title;
  List<String> boards;
  int currentIndex;
  bool isFinished;

  int get length => boards.length;
  int get currentBoard => int.parse(boards[currentIndex]);

  BoardPlayState({
    required this.title,
    required this.boards,
    this.currentIndex = 0,
    this.isFinished = false,
  });

  factory BoardPlayState.fromHistory({
    required String title,
    required BoardCategoryModel cate,
    required HistoryModel history,
  }) =>
      BoardPlayState(
        title: title,
        boards: cate.listBoardIDs,
      );

  factory BoardPlayState.fromCate({
    required String title,
    required BoardCategoryModel cate,
  }) =>
      BoardPlayState(
        title: title,
        boards: cate.listBoardIDs,
      );

  factory BoardPlayState.fromCategory({
    required BoardCategoryModel cate,
    required String title,
  }) =>
      BoardPlayState(
        title: title,
        boards: cate.listBoardIDs,
      );

  factory BoardPlayState.fromInstance(BoardPlayState instance) {
    return BoardPlayState(
      title: instance.title,
      boards: List.from(instance.boards),
      currentIndex: instance.currentIndex,
      isFinished: instance.isFinished,
    );
  }

  void changeBoardIndex(int index) {
    this.currentIndex = index;
  }
}
