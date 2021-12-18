import 'package:sathachlaixe/SQLite/quizSQLite.dart';
import 'package:sathachlaixe/UI/Login/profile_screen.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/Component/home_category.dart';
import 'package:sathachlaixe/UI/Component/searchbar.dart';
import 'package:sathachlaixe/UI/profile/profile_screen.dart';
import 'package:sathachlaixe/model/history.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import '../quizUI.dart';

import '../Test/test_list.dart';
import 'package:sathachlaixe/UI/Login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * .31,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage("assets/images/homebg.png"),
                    fit: BoxFit.fill),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Chào,',
                                    style: kText30Bold_14.copyWith(
                                      color: Colors.white,
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.h),
                                  child: Text(
                                      'Cùng luyện thi bằng lái nào!',
                                      style: kText18Medium_13),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 52.h,
                                  width: 52.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image:
                                            AssetImage("assets/images/avt.png"),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PersonalScreen()));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SearchBar(),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: <Widget>[
                    InkWell(
                      child: HomeCategory(
                        title: "Thi thử",
                        svgSrc: "assets/icons/ic_quiz.svg",
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TestList()));
                      },
                    ),
                    InkWell(
                      child: HomeCategory(
                        title: "Ôn tập lý thuyết",
                        svgSrc: "assets/icons/ic_assignment.svg",
                      ),
                    ),
                    InkWell(
                      child: HomeCategory(
                        title: "Ôn tập nhanh",
                        svgSrc: "assets/icons/ic_shuffle.svg",
                      ),
                    ),
                    InkWell(
                      child: HomeCategory(
                        title: "Biển báo",
                        svgSrc: "assets/icons/ic_board.svg",
                      ),
                    ),
                    InkWell(
                      child: HomeCategory(
                        title: "Câu hay sai",
                        svgSrc: "assets/icons/ic_fail.svg",
                      ),
                    ),
                    InkWell(
                      child: HomeCategory(
                        title: "Mẹo thi",
                        svgSrc: "assets/icons/ic_tips.svg",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
