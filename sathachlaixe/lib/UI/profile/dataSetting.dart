import 'dart:developer';

import 'package:sathachlaixe/UI/Component/mode_item.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/helper/helper.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/singleston/socketObserver.dart';
import 'package:sathachlaixe/singleston/socketio.dart';
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

class DataSettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DataSettingScreenState();
  }
}

class _DataSettingScreenState extends State<DataSettingScreen>
    with SocketObserver {
  UserModel? _userinfo;

  bool status = true;

  void onPressDeleteData(context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Xóa dữ liệu"),
              content: const Text(
                  "Tiến hành xóa cả dữ liệu trên thiết bị và dữ liệu trên server.\nDữ liệu sau khi xóa sẽ không thể khôi phục.\n Bạn thực sự muốn xóa?"),
              actions: [
                TextButton(
                  child: const Text("Tiếp tục"),
                  onPressed: () => Navigator.pop(context, "OK"),
                ),
                TextButton(
                  child: const Text("Hủy"),
                  onPressed: () => Navigator.pop(context, "Cancel"),
                ),
              ],
            )).then((value) {
      if (value == "OK") {
        log("Delete data sync and local");
        SocketController.instance.deleteData();
        repository.deleteAllData();
      }
    });
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

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 90.h,
                color: dtcolor1,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Stack(
                  children: <Widget>[
                    ReturnButton(),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Cài đặt dữ liệu",
                          style: kText20Bold_13,
                        ))
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    color: dtcolor13,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hạng bằng lái xe',
                          style: kText18Bold_14,
                        ),
                        new CustomRadio(),
                        if (isLogin)
                          SyncSwitch(
                            firstState: repository.isSyncON,
                            onChanged: (value) {
                              log("Changed sync state");
                            },
                          ),
                        SizedBox(
                          height: 10.h,
                        ),
                        if (isLogin)
                          InkWell(
                              onTap: () => onPressDeleteData(context),
                              child: Text(
                                'Xóa và đặt lại dữ liệu',
                                style: kText18Bold_14.copyWith(color: dtcolor4),
                              )),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SyncSwitch extends StatefulWidget {
  final Function(bool value)? onChanged;
  final bool firstState;
  SyncSwitch({required this.firstState, this.onChanged, Key? key})
      : super(key: key);
  @override
  _SyncSwitchState createState() =>
      new _SyncSwitchState(syncStatus: firstState);
}

class _SyncSwitchState extends State<SyncSwitch> {
  bool syncStatus = false;
  _SyncSwitchState({this.syncStatus = false});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.only(top: 10.h),
      title: Text(
        'Đồng bộ hóa',
        style: kText18Bold_14,
      ),
      value: syncStatus,
      onChanged: (value) async {
        if (!repository.isAuthorized) {
          showNotifyMessage(
              "Chưa đăng nhập", "Vui lòng đăng nhập để sử dụng chức năng");
          return;
        }
        if (value == repository.isSyncON) return;
        await repository.updateSyncState(value ? 1 : 0);
        widget.onChanged?.call(value);

        setState(() {
          syncStatus = repository.isSyncON;
        });
      },
    );
  }
}
