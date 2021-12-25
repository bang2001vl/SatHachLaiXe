import 'package:sathachlaixe/model/base.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryEvent extends BlocBaseEvent {}

class LoadHistory extends HistoryEvent {}

class HistoryBloc extends Bloc<BlocBaseEvent, Future<List<HistoryModel>>> {
  HistoryBloc(Future<List<HistoryModel>> initState) : super(initState) {
    on<LoadHistory>(_loadHistory);
  }

  void _loadHistory(HistoryEvent event, Emitter emit) {}

  static final empty = Future.delayed(Duration.zero,
      () => List.generate(20, (index) => new HistoryModel(topicID: index + 1)));
}
