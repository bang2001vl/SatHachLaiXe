import 'dart:developer';
import 'dart:ffi';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/UI/Component/test.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/size.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Component/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';

import '../quizUI.dart';

class TestList extends StatelessWidget {
  Widget buildWithBloc(BuildContext context) {
    return FutureBuilder<List<HistoryModel>>(
        future: repository.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return buildContent(context, snapshot.data!);
          }

          if (snapshot.hasError) {
            return buildError(context, snapshot.error!);
          }

          return buildLoading(context);
        });
  }

  Widget buildError(BuildContext context, Object error) {
    return Text("Có lỗi xảy ra");
  }

  Widget buildLoading(BuildContext context) {
    return Text("Đang tải...");
  }

  void onPressTest(BuildContext context, HistoryModel lastestHistory) {
    if (lastestHistory.isFinished || !lastestHistory.hasStarted) {
      beginQuiz(context, lastestHistory);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Chưa hoàn thành"),
          content: const Text("Bạn có muốn tiếp tục lần thi trước?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 1),
              child: const Text('Làm lại'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 2),
              child: const Text('Tiếp tục'),
            ),
          ],
        ),
      ).then((value) {
        if (value == 1) {
          if (lastestHistory.isRandomTopic()) {
            beginQuiz(context, repository.getRandomTopic());
          } else {
            beginQuiz(context, lastestHistory);
          }
        } else if (value == 2) {
          resumeQuiz(context, lastestHistory);
        }
      });
    }
  }

  void resumeQuiz(context, HistoryModel history) async {
    var quizlist = await history.getQuizList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return QuizPage.fromHistory(history,
              title: "Đề " + history.topicID.toString(), quizlist: quizlist);
        },
      ),
    );
  }

  void beginQuiz(context, HistoryModel history) async {
    var quizlist = await history.getQuizList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return QuizPage(
            title: history.isRandomTopic()
                ? "Đề ngẫu nhiên"
                : "Đề " + history.topicID.toString(),
            quizlist: quizlist,
            topicId: history.topicID,
            timeLimit: repository.getTimeLimit(),
          );
        },
      ),
    );
  }

  Widget buildContent(context, List<HistoryModel> testList) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage("assets/images/quizzbg.png"),
                fit: BoxFit.fill),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 15.h, bottom: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ReturnButton(),
                    Text('THI THỬ', style: kText24Bold_13),
                    IconButton(
                      onPressed: () {
                        var topic = repository.getRandomTopic();
                        onPressTest(context, topic);
                      },
                      iconSize: 35.h,
                      icon: SvgPicture.asset('assets/icons/shuffle.svg'),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
                  child: GridView.builder(
                    itemCount: testList.length,
                    itemBuilder: (context, index) {
                      var item = testList[index];
                      return InkWell(
                        child: TestComponent(
                          isPassed: item.isPassed,
                          title: item.isRandomTopic()
                              ? "ĐỀ NGẪU NHIÊN"
                              : "ĐỀ SỐ " + index.toString(),
                          totalQues: item.count,
                          trueQues: item.countCorrect(),
                        ),
                        onTap: () {
                          onPressTest(context, item);
                        },
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.w,
                      mainAxisSpacing: 15.w,
                      mainAxisExtent: 220.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildWithBloc(context);
  }
}
