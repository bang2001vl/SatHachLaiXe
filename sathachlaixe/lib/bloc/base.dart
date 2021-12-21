import 'package:flutter_bloc/flutter_bloc.dart';

class IReloadableBloc<T> extends Cubit<List<T>> {
  IReloadableBloc(List<T> initState) : super(initState);
  void reload() {
    emit(List.from(state));
  }
}
