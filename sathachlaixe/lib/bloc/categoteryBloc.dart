import 'package:sathachlaixe/bloc/base.dart';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/questionCategory.dart';
import 'package:sathachlaixe/singleston/socketObserver.dart';
import 'package:sathachlaixe/singleston/socketio.dart';

class CategoteryBloc extends IReloadableBloc<QuestionCategoryModel>
    with SocketObserver {
  CategoteryBloc(List<QuestionCategoryModel> initState) : super(initState) {
    SocketBinding.instance.addObserver(this);
  }

  @override
  void onDataChanged(
      List<HistoryModel> newHistories, List<PracticeModel> newPratices) {
    reload();
  }

  @override
  Future<void> close() {
    SocketBinding.instance.removeObserver(this);
    return super.close();
  }
}
