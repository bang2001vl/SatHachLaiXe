import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathachlaixe/model/topic.dart';

class TopicBloc extends Cubit<List<TopicModel>> {
  TopicBloc(List<TopicModel> initState) : super(initState);
  void reload() {
    emit(List.from(state));
  }
}
