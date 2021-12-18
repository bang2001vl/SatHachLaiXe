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
import 'package:vector_math/vector_math.dart' as vmath;
import 'dart:math' as math;
import '../quizUI.dart';

class ResultTest extends StatelessWidget {
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
                image: AssetImage("assets/images/result_pass_bg.png"),
                fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100.h,
              ),
              Stack(alignment: Alignment.center, children: [
                CustomPaint(painter: CustomCircularProgress(value: 0.75)),
                Column(
                  children: [
                    Text(
                      "75%",
                      style: kText35Bold_1.copyWith(
                          fontSize: ScreenUtil().setSp(50.sp)),
                    ),
                    Text(
                      "30/30",
                      style: kText20Medium_10,
                    ),
                  ],
                )
              ]),
              SizedBox(
                height: 30.h,
              ),
              Image.asset('assets/icons/key.png'),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Chúc mừng!",
                style: kText35Bold_14,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Bạn đã đạt bài thi này,\n Chúc bạn có kết quả như mong đợi!",
                textAlign: TextAlign.center,
                style: kText20Medium_10,
              ),
              SizedBox(
                height: 60.h,
              ),
              GestureDetector(
                child: Container(
                  height: 60.h,
                  width: 250.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38),
                    color: dtcolor1,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Xem chi tiết',
                    style: kText22Bold_13,
                  ),
                ),
                onTap: () {},
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                "Trở về trang chủ",
                style: kText18Bold_3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCircularProgress extends CustomPainter {
  final double value;

  CustomCircularProgress({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawArc(
      Rect.fromCenter(center: center, width: 170, height: 170),
      vmath.radians(140),
      vmath.radians(260),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black12
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 20,
    );
    canvas.saveLayer(
      Rect.fromCenter(center: center, width: 200, height: 200),
      Paint(),
    );

    const Gradient gradient = SweepGradient(
      startAngle: 1.25 * math.pi / 2,
      endAngle: 5.5 * math.pi / 2,
      tileMode: TileMode.repeated,
      colors: <Color>[
        Colors.blueAccent,
        Colors.lightBlueAccent,
      ],
    );
    canvas.drawArc(
      Rect.fromCenter(center: center, width: 170, height: 170),
      vmath.radians(140),
      vmath.radians(260 * value),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..shader = gradient
            .createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
        ..strokeWidth = 20,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
