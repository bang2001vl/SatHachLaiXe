import 'package:sathachlaixe/bloc/base.dart';
import 'package:sathachlaixe/model/boardCategory.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class BoardCategoteryBloc extends IReloadableBloc<BoardCategoryModel> {
  BoardCategoteryBloc(List<BoardCategoryModel> initState) : super(initState);

  @override
  void reload() async {
    var list = await repository.getBoardCategory();
    emit(list);
  }
}
