import 'package:sathachlaixe/model/base.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/state/quiz.dart';

class QuizEvent extends BlocBaseEvent {
  HistoryModel data;
  QuizEvent({required this.data});
}

class SaveHistory extends QuizEvent {
  bool isFinished;
  SaveHistory({required HistoryModel data, required this.isFinished})
      : super(data: data);
}

class QuizBloc extends Bloc<BlocBaseEvent, Future<QuizState>> {
  QuizBloc({id}) : super(empty) {
    on<SaveHistory>(_saveHistory);
  }

  QuizBloc.fromState(QuizState state) : super(Future.value(state));

  void _saveHistory(SaveHistory event, Emitter emit) {
    repository.insertHistory(event.data);
    emit(state);
  }

  static get empty => Future.delayed(Duration.zero, () => QuizState.empty());
}
