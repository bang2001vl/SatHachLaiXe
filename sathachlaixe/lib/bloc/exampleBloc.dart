import 'dart:developer';

import 'package:sathachlaixe/model/base.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class HistoryEvent extends BlocBaseEvent {}

class LoadHistory extends HistoryEvent {}

class HistoryBloc extends Cubit<List<HistoryModel>> {
  HistoryBloc(List<HistoryModel> initState) : super(initState) {
    reload();
  }
  void reload() async {
    log("Call reload bloc");
    var a = await repository.getHistory();
    emit(a);
  }

  static final empty = Future.delayed(Duration.zero,
      () => List.generate(20, (index) => new HistoryModel(topicID: index + 1)));
}
