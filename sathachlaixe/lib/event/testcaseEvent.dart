import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sathachlaixe/model/history.dart';

abstract class TestEvent extends Equatable {
  TestEvent();
}

class TestStatedEventChanged extends TestEvent {
  final bool hasStarted;
  TestStatedEventChanged({required this.hasStarted})
      : assert(hasStarted != null);
  @override
  // TODO: implement props
  List<Object> get props => [hasStarted];
}
