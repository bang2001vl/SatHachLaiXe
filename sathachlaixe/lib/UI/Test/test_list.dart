import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
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
<<<<<<< Updated upstream
=======
import 'package:sathachlaixe/bloc/exampleBloc.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';
>>>>>>> Stashed changes

import '../quizUI.dart';

class TestList extends StatelessWidget {
<<<<<<< Updated upstream
  Future<List<QuizBaseDB>> getQuizList(List questionIDs) async {
    List<QuizBaseDB> quizs = List<QuizBaseDB>.empty(growable: true);
    var db = QuizDB();
    for (int i = 0; i < questionIDs.length; i++) {
      quizs.add(await db.findQuizById(questionIDs[i]));
=======
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => HistoryBloc(List.empty()),
      child: TestListPage(),
    );
  }
}

class TestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HistoryBloc, List<HistoryModel>>(
        builder: buildContent,
      ),
    );
  }

  Widget buildWithBloc(BuildContext context, Future<List<HistoryModel>> state) {
    return FutureBuilder<List<HistoryModel>>(
        future: state,
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
>>>>>>> Stashed changes
    }
    return quizs;
  }

<<<<<<< Updated upstream
  void onPressTest(BuildContext context) {
    var db = QuizDB();
    db.ensureDB().whenComplete(() {
      getQuizList(List.generate(30, (index) => index + 400)).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return QuizPage(
                title: 'Test Quiz',
                quizlist: value,
                topicId: 1,
                timeLimit: Duration(minutes: 30),
              );
            },
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () => onPressTest(context),
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
                    itemCount: 10,
                    itemBuilder: (context, index) => InkWell(
                      child: TestComponent(
                        isTested: true,
                        title: "ĐỀ SỐ 1 ",
                        percentTest: 50,
                        trueQues: 25,
                        color: dtcolor1,
                      ),
                      onTap: () => onPressTest(context),
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.w,
                      mainAxisSpacing: 15.w,
                      mainAxisExtent: 220.h,
                    ),
=======
  void resumeQuiz(context, HistoryModel history) async {
    var quizlist = await history.getQuizList();
    var quizPage = QuizPage.fromHistory(
      history,
      title: "Đề " + history.topicID.toString(),
      quizlist: quizlist,
    );
    openQuizPage(context, quizPage);
  }

  void beginQuiz(context, HistoryModel history) async {
    var quizlist = await history.getQuizList();
    var quizPage = QuizPage(
      title: history.isRandomTopic()
          ? "Đề ngẫu nhiên"
          : "Đề " + history.topicID.toString(),
      quizlist: quizlist,
      topicId: history.topicID,
      timeLimit: repository.getTimeLimit(),
    );
    openQuizPage(context, quizPage);
  }

  void openQuizPage(BuildContext context, QuizPage quizPage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => quizPage,
      ),
    ).then((value) {
      if (value != "Cancel") {
        log("History has changed");
        context.read<HistoryBloc>().reload();
      }
    });
  }

  Widget buildContent(BuildContext context, List<HistoryModel> testList) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("assets/images/quizzbg.png"), fit: BoxFit.fill),
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
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
                child: GridView.builder(
                  itemCount: testList.length,
                  itemBuilder: (context, index) {
                    var item = testList[index];
                    if (item.hasStarted) {
                      return InkWell(
                        child: TestStartedComponent(
                          isFinished: item.isFinished,
                          isPassed: item.isPassed,
                          title: item.isRandomTopic()
                              ? "ĐỀ NGẪU NHIÊN"
                              : "ĐỀ SỐ " + item.topicID.toString(),
                          totalQues: item.count,
                          trueQues: item.countCorrect(),
                          completeQues: item.countSelected(),
                        ),
                        onTap: () {
                          onPressTest(context, item);
                        },
                      );
                    } else {
                      return InkWell(
                        child: TestUnstartedComponent(
                          isCompleted: item.isFinished,
                          title: item.isRandomTopic()
                              ? "ĐỀ NGẪU NHIÊN"
                              : "ĐỀ SỐ " + item.topicID.toString(),
                          totalQues: item.count,
                          time: item.timeLeft,
                        ),
                        onTap: () {
                          onPressTest(context, item);
                        },
                      );
                    }
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.w,
                    mainAxisExtent: 225.h,
>>>>>>> Stashed changes
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
