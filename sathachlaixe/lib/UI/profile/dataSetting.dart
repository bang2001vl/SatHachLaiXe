import 'dart:developer';

import 'package:sathachlaixe/UI/Component/mode_item.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/singleston/socketObserver.dart';
import 'package:sathachlaixe/singleston/socketio.dart';

class DataSettingScreen extends StatelessWidget {
  bool status = true;

  void onPressDeleteData(context) {
    log("Delete data sync");
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
        SocketController.instance.deleteData();
      }
    });
  }

  @override
  Widget build(context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
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
                        SyncSwitch(
                          firstState: repository.isSyncON,
                          onChanged: (value) {
                            log("Changed sync state");
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
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

class _SyncSwitchState extends State<SyncSwitch> with SocketObserver {
  bool syncStatus = false;
  _SyncSwitchState({this.syncStatus = false});

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
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.only(top: 10.h),
      title: Text(
        'Đồng bộ hóa',
        style: kText18Bold_14,
      ),
      value: syncStatus,
      onChanged: (value) async {
        if (value == repository.isSyncON) return;
        await repository.updateSyncState(value ? 1 : 0);
        widget.onChanged?.call(value);

        setState(() {
          syncStatus = value;
        });
      },
    );
  }

  // @override
  // void onAuthorized() {
  //   setState(() {
  //     syncStatus = true;
  //   });
  // }

  // @override
  // void onDisconnect() {
  //   setState(() {
  //     syncStatus = false;
  //   });
  // }
}
