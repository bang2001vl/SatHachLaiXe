import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sathachlaixe/bloc/base.dart';
import 'package:sathachlaixe/model/questionCategory.dart';

class CategoteryBloc extends IReloadableBloc<QuestionCategoryModel> {
  CategoteryBloc(List<QuestionCategoryModel> initState) : super(initState);
}
