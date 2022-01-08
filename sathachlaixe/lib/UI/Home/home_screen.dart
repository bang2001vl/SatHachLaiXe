import 'dart:typed_data';

import 'package:flutter_svg/svg.dart';
import 'package:sathachlaixe/UI/Board/boardCategoryList.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/QuickTest/selectQuesCategory.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/Component/home_category.dart';
import 'package:sathachlaixe/UI/Component/searchbar.dart';
import 'package:sathachlaixe/UI/Tips/tips_screen.dart';
import 'package:sathachlaixe/UI/WrongQues/topWrong_screen.dart';
import 'package:sathachlaixe/UI/profile/profile_screen.dart';
import 'package:sathachlaixe/UI/studyQues/quesCategory_sceen.dart';
import 'package:sathachlaixe/model/user.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/singleston/socketObserver.dart';
import 'package:sathachlaixe/singleston/socketio.dart';

import '../Test/test_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 160.h,
              decoration: BoxDecoration(
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
                        padding: EdgeInsets.only(top: 60.h),
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
                                      style: kText14Medium_13),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: InkWell(
                                child: UserAvatarWidget(),
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
                      // SearchBar(),
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    QuesCategoryScreenWithBloc()));
                      },
                    ),
                    InkWell(
                      child: HomeCategory(
                        title: "Ôn tập nhanh",
                        svgSrc: "assets/icons/ic_shuffle.svg",
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuickTestScreen()));
                      },
                    ),
                    InkWell(
                      child: HomeCategory(
                        title: "Biển báo",
                        svgSrc: "assets/icons/ic_board.svg",
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BoardCategoryScreen()));
                      },
                    ),
                    InkWell(
                      child: HomeCategory(
                        title: "Câu hay sai",
                        svgSrc: "assets/icons/ic_fail.svg",
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TopWrongScreen()));
                      },
                    ),
                    InkWell(
                      child: HomeCategory(
                        title: "Mẹo thi",
                        svgSrc: "assets/icons/ic_tips.svg",
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TipsScreen()));
                      },
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

class UserAvatarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserAvatarWidgetState();
  }
}

class _UserAvatarWidgetState extends State<UserAvatarWidget>
    with SocketObserver {
  UserModel? _userinfo;

  @override
  void initState() {
    super.initState();
    SocketBinding.instance.addObserver(this);
    setState(() {
      _userinfo = AppConfig.instance.userInfo;
    });
  }

  @override
  void onUserInfoChanged() {
    setState(() {
      _userinfo = AppConfig.instance.userInfo;
    });
  }

  @override
  void dispose() {
    SocketBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var defaultAvatar = Image.asset("assets/images/notUser.png");
    var avatar = defaultAvatar;
    if (_userinfo != null) {
      var userInfo = _userinfo as UserModel;
      if (userInfo.hasImage) {
        var bytes = userInfo.rawimage!;

        avatar = Image.memory(
          Uint8List.fromList(bytes),
        );
      } else {
        avatar = Image.asset("assets/images/avtProfile.png");
      }
    }

    return Container(
      alignment: Alignment.center,
      height: 52.h,
      width: 52.h,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        image: DecorationImage(image: avatar.image, fit: BoxFit.fill),
      ),
    );
  }
}
