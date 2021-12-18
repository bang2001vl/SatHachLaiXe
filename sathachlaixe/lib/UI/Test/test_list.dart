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

import '../quizUI.dart';

class TestList extends StatelessWidget {
  Future<List<QuizBaseDB>> getQuizList(List questionIDs) async {
    List<QuizBaseDB> quizs = List<QuizBaseDB>.empty(growable: true);
    var db = QuizDB();
    for (int i = 0; i < questionIDs.length; i++) {
      quizs.add(await db.findQuizById(questionIDs[i]));
    }
    return quizs;
  }

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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
