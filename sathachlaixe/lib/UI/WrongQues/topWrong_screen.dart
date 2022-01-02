import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sathachlaixe/UI/Component/back_button.dart';
import 'package:sathachlaixe/UI/Component/top_wrong.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/helper.dart';
import 'package:sathachlaixe/UI/studyQues/studyQuiz_screen.dart';
import 'package:sathachlaixe/repository/sqlite/questionStatistic.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/singleston/socketObserver.dart';
import 'package:sathachlaixe/singleston/socketio.dart';

class TopWrongScreen extends StatefulWidget {
  TopWrongScreen({Key? key}) : super(key: key);

  final int length = 10;

  @override
  State<StatefulWidget> createState() {
    return _TopWrongScreenState(repository.getTopWrong(length));
  }
}

class _TopWrongScreenState extends State<TopWrongScreen> with SocketObserver {
  late Future<List<QuestionStatistic>> _dataFuture;
  List<QuestionStatistic>? _data;

  _TopWrongScreenState(Future<List<QuestionStatistic>> initState) {
    _dataFuture = initState;
  }

  @override
  void initState() {
    super.initState();
    SocketBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    SocketBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onDataChanged() {
    reloadData();
  }

  void reloadData() {
    setState(() {
      _dataFuture = repository.getTopWrong(widget.length);
    });
  }

  void onPressPlay(context) {
    if (this._data == null || this._data!.length < 1) {
      return;
    }
    var data = this._data!;
    var questionIds = data.map((e) => e.questionId).toList();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizStudyScreen.modePratice(questionIds),
        ));
  }

  void onPressItem(BuildContext context, String questionId) {
    var questionIds = List.of([questionId]);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizStudyScreen.modePratice(questionIds),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: dtcolor16,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: 200.h,
                color: dtcolor1,
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: 20.w, top: 20.h, left: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        BackButtonComponent(),
                        Text(
                          "TOP CÂU HAY SAI",
                          style: kText20Bold_13,
                        ),
                        InkWell(
                          onTap: () => onPressPlay(context),
                          child: Container(
                            height: 30.h,
                            width: 30.h,
                            child: SvgPicture.asset('assets/icons/play.svg'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.only(left: 20.w, right: 20.w, top: 30.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: dtcolor11,
                              blurRadius: 2,
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 20.h),
                        child: FutureBuilder(
                            future: _dataFuture,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return buildError(context, snapshot.error);
                              }

                              if (snapshot.hasData) {
                                this._data =
                                    (snapshot.data as List<QuestionStatistic>);
                                return buildItemWidget(context, this._data!);
                              }

                              return buildLoading(context);
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItemWidget(
      BuildContext context, List<QuestionStatistic> dataList) {
    if (dataList.length == 0) {
      return Center(
        child: Text("Chưa có dữ liệu"),
      );
    }

    var cataNames = repository.getQuestionCategory();
    // Remove criscata
    cataNames.removeLast();
    // Remove all cata
    cataNames.removeAt(0);

    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        var data = dataList[index];
        var questionId = data.questionId;
        var wrongTime = data.countWrong;
        var cate = cataNames
            .where((element) => element.questionIDs.contains(questionId))
            .first
            .name;

        return GestureDetector(
          onTap: () => onPressItem(context, questionId),
          child: TopWrongItem(
            name: "Câu $questionId",
            top: index + 1,
            wrongTime: wrongTime,
            cate: cate,
          ),
        );
      },
    );
  }
}
