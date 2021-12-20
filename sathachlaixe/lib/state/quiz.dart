import 'package:flutter/material.dart';
import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/bloc/exampleBloc.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/topic.dart';

class QuizState {
  /** Zero is start (or restart) quiz. One review quiz. Two is resume quiz*/
  int mode;
  int currentIndex;
  int selectedAnswer;

  late HistoryModel history;
  late TopicModel topic;

  bool get isUpdate => mode == 2;
  int get length => topic.questionIDs.length;
  Duration get timeLeft => history.timeLeft;

  QuizState({
    required this.mode,
    required this.history,
    required this.topic,
    this.currentIndex = 0,
    this.selectedAnswer = 0,
  });

  QuizState.fromHistory(
    this.topic,
    this.history, {
    this.mode = 1,
    this.currentIndex = 0,
    this.selectedAnswer = 0,
  });

  QuizState.fromTopic(
    this.topic, {
    this.mode = 0,
    this.currentIndex = 0,
    this.selectedAnswer = 0,
  }) {
    this.history = HistoryModel.fromTopic(this.topic);
  }

  void selectAnswer(int select, int correct) {
    history.selectedAns[currentIndex] = select.toString();
    history.correctAns[currentIndex] = correct.toString();
  }

  void changeQuestionIndex(int index) {
    this.currentIndex = index;
  }
}
