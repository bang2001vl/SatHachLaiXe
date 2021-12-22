import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';

class QuizClock extends StatelessWidget {
  final Duration timeLeft;
  QuizClock(this.timeLeft, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset('assets/icons/quiz_clock_bg.svg'),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset('assets/icons/ic_clock.svg'),
            SizedBox(
              width: 5,
            ),
            Text(
                timeLeft.inMinutes.toString().padLeft(2, '0') +
                    ':' +
                    timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0'),
                style: kText12Normal_13),
          ],
        ),
      ],
    );
  }
}
