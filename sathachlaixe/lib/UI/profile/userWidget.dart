import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/model/user.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/singleston/socketObserver.dart';
import 'package:sathachlaixe/singleston/socketio.dart';

class UserAvatarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserAvatarWidgetState();
  }
}

class _UserAvatarWidgetState extends State<UserAvatarWidget>
    with SocketObserver {
  UserModel? _userinfo;

  void onClick(context) {
    if (_userinfo == null) {
      repository.auth.showLogin(context);
    }
  }

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
    var avatar = Image.asset("assets/images/avtProfile.png");
    String name = "Đăng nhập";
    String phone = "";
    if (_userinfo != null) {
      var userInfo = _userinfo as UserModel;
      if (userInfo.image != null) {
        var bytes = Utf8Encoder().convert(userInfo.image!);
        avatar = Image.memory(bytes);
      }
      name = userInfo.name;
    }

    return GestureDetector(
      onTap: () => onClick(context),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 20.h),
            child: ReturnButton(),
          ),
          SizedBox(
            height: 50.h,
          ),
          CircleAvatar(
            radius: 50.h,
            backgroundImage: avatar.image,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            name,
            style: kText16Medium_1.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(20.sp),
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            phone,
            style: kText16Medium_1.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(12.sp),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
