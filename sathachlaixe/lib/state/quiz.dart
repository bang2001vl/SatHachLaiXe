import 'package:flutter/material.dart';
import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/bloc/exampleBloc.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class QuizState {
  String title;
  /** Zero is start (or restart) quiz. One review quiz. Two is resume quiz*/
  int mode;
  List<String> questionIds;
  List<String> selectedList;
  List<String> correctList;
  Object? tag;
  Duration timeLeft;
  int currentIndex;
  bool isFinished;

  bool get isUpdate => mode == 2;
  int get length => questionIds.length;
  int get currentQuestionId => int.parse(questionIds[currentIndex]);
  List<int> getQuestionIDsListInt() =>
      this.questionIds.map((e) => int.parse(e)).toList();
  List<int> getSelectedListInt() =>
      this.selectedList.map((e) => int.parse(e)).toList();
  List<int> getCorrectListInt() =>
      this.correctList.map((e) => int.parse(e)).toList();
  int get selectedAnswer => int.parse(selectedList[currentIndex]);
  int get correctAnswer => int.parse(correctList[currentIndex]);
  QuizState({
    required this.title,
    required this.mode,
    required this.questionIds,
    required this.selectedList,
    required this.correctList,
    required this.timeLeft,
    this.currentIndex = 0,
    this.isFinished = false,
    this.tag,
  });

  factory QuizState.fromHistory({
    required String title,
    required TopicModel topic,
    required HistoryModel history,
    int mode = 1,
  }) =>
      QuizState(
        title: title,
        mode: mode,
        questionIds: topic.questionIDs,
        selectedList: history.selectedAns,
        correctList: history.correctAns,
        timeLeft: history.timeLeft,
        tag: topic,
      );

  factory QuizState.fromTopic({
    required String title,
    required TopicModel topic,
    int mode = 0,
  }) =>
      QuizState(
        title: title,
        mode: mode,
        questionIds: topic.questionIDs,
        selectedList: List.filled(topic.questionIDs.length, "0"),
        correctList: List.filled(topic.questionIDs.length, "-1"),
        timeLeft: repository.getTimeLimit(),
        tag: topic,
      );

  factory QuizState.fromCategory({
    required QuestionCategoryModel cate,
    required String title,
    int mode = 3,
  }) =>
      QuizState(
        title: title,
        mode: mode,
        questionIds: cate.questionIDs,
        selectedList: List.filled(cate.questionIDs.length, "0"),
        correctList: List.filled(cate.questionIDs.length, "-1"),
        timeLeft: repository.getTimeLimit(),
      );

  factory QuizState.fromInstance(QuizState instance) {
    return QuizState(
        title: instance.title,
        mode: instance.mode,
        questionIds: List.from(instance.questionIds),
        selectedList: List.from(instance.selectedList),
        correctList: List.from(instance.correctList),
        timeLeft: instance.timeLeft,
        currentIndex: instance.currentIndex,
        isFinished: instance.isFinished,
        tag: instance.tag);
  }

  void selectAnswer(int select, int correct) {
    selectedList[currentIndex] = select.toString();
    correctList[currentIndex] = correct.toString();
  }

  void changeQuestionIndex(int index) {
    this.currentIndex = index;
  }
}
