import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Component/profileMenuItem.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Login/profile_screen.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/model/user.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/singleston/socketObserver.dart';
import 'package:sathachlaixe/singleston/socketio.dart';

import 'dataSetting.dart';

class MenuWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenuWidgetState();
  }
}

void onPressLogout() {
  repository.auth.logout();
}

class _MenuWidgetState extends State<MenuWidget> with SocketObserver {
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
    bool isLogin = false;

    if (_userinfo != null) {
      var userInfo = _userinfo as UserModel;
      isLogin = true;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 17.h,
          ),
          Text(
            'Cài đặt',
            style: kText16Medium_1.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(20.sp),
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          if (isLogin)
            ProfileMenuItem(
              iconSrc: 'assets/icons/private.svg',
              title: 'Thông tin cá nhân',
              check: true,
              color: cwcolor23,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
          if (isLogin)
            ProfileMenuItem(
              iconSrc: "assets/icons/password.svg",
              title: 'Đổi mật khẩu',
              check: true,
              color: cwcolor22,
              onTap: () {},
            ),
          ProfileMenuItem(
            iconSrc: 'assets/icons/security.svg',
            title: 'Cài đặt dữ liệu',
            check: true,
            color: cwcolor24,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DataSettingScreen()));
            },
          ),
          SizedBox(
            height: 25.h,
          ),
          Text(
            'Quy định và chính sách',
            style: kText16Medium_1.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(20.sp),
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          ProfileMenuItem(
            iconSrc: 'assets/icons/termOfUse.svg',
            title: 'Quy định sử dụng',
            check: true,
            color: cwcolor24,
            onTap: () {},
          ),
          ProfileMenuItem(
            iconSrc: 'assets/icons/QA.svg',
            title: 'Q&A',
            check: false,
            color: dtcolor7,
            onTap: () {},
          ),
          ProfileMenuItem(
            iconSrc: 'assets/icons/share.svg',
            title: 'Chia sẻ ứng dụng',
            check: false,
            color: cwcolor23,
            onTap: () {},
          ),
          if (isLogin)
            ProfileMenuItem(
              iconSrc: 'assets/icons/signout.svg',
              title: 'Đăng xuất',
              check: false,
              color: cwcolor23,
              onTap: () => onPressLogout(),
            ),
        ],
      ),
    );
  }
}
