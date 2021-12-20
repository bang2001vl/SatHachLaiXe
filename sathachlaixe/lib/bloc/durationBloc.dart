import 'package:flutter_bloc/flutter_bloc.dart';

class DurationBloc extends Cubit<Duration> {
  DurationBloc(Duration initState) : super(initState);

  void changeTo(Duration duration) {
    emit(duration);
  }

  void minus(Duration duration) {
    emit(state - duration);
  }

  void plus(Duration duration) {
    emit(state + duration);
  }
}
