import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathachlaixe/bloc/base.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sathachlaixe/model/questionCategory.dart';

class BoardCategoteryBloc extends IReloadableBloc<BoardCategoryModel> {
  BoardCategoteryBloc(List<BoardCategoryModel> initState) : super(initState);
}
