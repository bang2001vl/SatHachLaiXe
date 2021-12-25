import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sathachlaixe/UI/Component/back_button.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:sathachlaixe/UI/Component/top_wrong.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopWrongScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: dtcolor16,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: 200.h,
                color: dtcolor1,
              ),
              Column(
                children: [
                  Container(
                    height: 100.h,
                    padding: EdgeInsets.only(left: 20.w),
                    child: Stack(
                      children: <Widget>[
                        BackButtonComponent(),
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              "TOP CÂU SAI",
                              style: kText20Bold_13,
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        margin:
                            EdgeInsets.only(left: 20.w, right: 20.w, top: 30.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: dtcolor11,
                                blurRadius: 2,
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 20.h),
                          child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) => TopWrongItem(
                                    name: "Câu 1",
                                    top: index + 1,
                                    wrongTime: 4,
                                    cate: "Câu điểm liệt",
                                  )),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
