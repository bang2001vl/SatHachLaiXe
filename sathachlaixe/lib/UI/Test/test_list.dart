import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Component/test.dart';
import 'package:sathachlaixe/UI/Component/testUnStarted.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/helper.dart';
import 'package:sathachlaixe/UI/testUI.dart';
import 'package:sathachlaixe/bloc/exampleBloc.dart';
import 'package:sathachlaixe/bloc/topicBloc.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/model/topic.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class TestList extends StatelessWidget {
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
          child: BlocProvider<TopicBloc>(
            create: (_) => TopicBloc(repository.getTopoicDemos()),
            child: BlocBuilder<TopicBloc, List<TopicModel>>(
              builder: (context, topics) => TestListPage(topics),
            ),
          ),
        ),
      ),
    );
  }
}

class TestListPage extends StatelessWidget {
  final List<TopicModel> topics;
  TestListPage(this.topics, {Key? key}) : super(key: key);

  void onPressTest(
      BuildContext context, TopicModel topic, HistoryModel lastestHistory) {
    if (!lastestHistory.hasStarted) {
      beginQuiz(context, topic);
    } else if (lastestHistory.isFinished) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Chọn hành động"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 1),
              child: const Text('Làm lại'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 2),
              child: const Text('Xem kết quả'),
            ),
          ],
        ),
      ).then((value) {
        if (value == 1) {
          beginQuiz(context, topic);
        } else if (value == 2) {
          reviewQuiz(context, topic, lastestHistory);
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Chọn hành động"),
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
          beginQuiz(context, topic);
        } else if (value == 2) {
          resumeQuiz(context, topic, lastestHistory);
        }
      });
    }
  }

  void resumeQuiz(context, TopicModel topic, HistoryModel history) {
    var quizPage = QuizPageWithBloc.modeResume(topic: topic, history: history);
    openQuizPage(context, quizPage);
  }

  void beginQuiz(context, TopicModel topic) {
    var quizPage = QuizPageWithBloc.modeStart(topic: topic);
    openQuizPage(context, quizPage);
  }

  void onPressRandomTest(BuildContext context) {
    var quizPage = QuizPageWithBloc.modeStart(
      topic: repository.getRandomTopic(),
    );
    openQuizPage(context, quizPage);
  }

  void reviewQuiz(context, TopicModel topic, HistoryModel history) {
    var quizPage = QuizPageWithBloc.modeReview(topic: topic, history: history);
    openQuizPage(context, quizPage);
  }

  void openQuizPage(BuildContext context, QuizPageWithBloc quizPage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => quizPage,
      ),
    ).then((value) {
      if (value != "Cancel") {
        log("History has changed");
        context.read<TopicBloc>().reload();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h, bottom: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ReturnButton(),
              Text('THI THỬ', style: kText24Bold_13),
              IconButton(
                onPressed: () => onPressRandomTest(context),
                iconSize: 35.h,
                icon: SvgPicture.asset('assets/icons/shuffle.svg'),
              )
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
            child: buildWithFuture(context, topics),
          ),
        ),
      ],
    );
  }

  Widget buildWithFuture(BuildContext context, List<TopicModel> topics) {
    return FutureBuilder<List<HistoryModel?>>(
        future: repository.getLastestHistoryList(
            List.generate(topics.length, (index) => topics[index].topicId)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            //log("has data");
            return buildContent(context, topics, snapshot.data!);
          }

          if (snapshot.hasError) {
            return buildError(context, snapshot.error!);
          }

          return buildLoading(context);
        });
  }

  Widget buildContent(
      context, List<TopicModel> topics, List<HistoryModel?> histories) {
    return GridView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        var history = histories[index] == null
            ? HistoryModel.fromTopic(topics[index])
            : histories[index]!;
        return buildTopic(context, topics[index], history);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.w,
        mainAxisExtent: 225.h,
      ),
    );
  }

  Widget buildTopic(
      BuildContext context, TopicModel topic, HistoryModel history) {
    if (history.hasStarted) {
      return InkWell(
        child: TestStartedComponent(
          isFinished: history.isFinished,
          isPassed: history.isPassed,
          title: history.isRandomTopic()
              ? "ĐỀ NGẪU NHIÊN"
              : "ĐỀ SỐ " + history.topicID.toString(),
          totalQues: history.count,
          trueQues: history.countCorrect(),
          completeQues: history.countSelected(),
        ),
        onTap: () {
          onPressTest(context, topic, history);
        },
      );
    } else {
      var history = HistoryModel.fromTopic(topic);
      return InkWell(
        child: TestUnstartedComponent(
          title: topic.isRandom
              ? "ĐỀ NGẪU NHIÊN"
              : "ĐỀ SỐ " + topic.topicId.toString(),
          totalQues: history.count,
          time: history.timeLeft,
        ),
        onTap: () {
          onPressTest(context, topic, history);
        },
      );
    }
  }
}
