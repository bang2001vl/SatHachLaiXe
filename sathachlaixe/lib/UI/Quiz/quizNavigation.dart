import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizNavigationWidget extends StatelessWidget {
  final List<int> selected;
  final int mode;
  final Function(int index)? onSelect;

  late final List<int> correct;

  int get maximum => selected.length;
  int _getCorrectIndex(int index) => correct.elementAt(index);

  QuizNavigationWidget(this.selected, this.correct, this.mode,
      {Key? key, this.onSelect})
      : super(key: key);
  QuizNavigationWidget.modeStart(this.selected,
      {this.mode = 0, Key? key, this.onSelect})
      : super(key: key);
  QuizNavigationWidget.modeReview(this.selected, this.correct,
      {this.mode = 1, Key? key, this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firstLine = new List<Widget>.empty(growable: true);
    for (int i = 0; i < maximum && i < 10; i++) {
      firstLine.add(getQuesNavigationIcon(i));
    }
    var secondLine = new List<Widget>.empty(growable: true);
    for (int i = 10; i < maximum && i < 20; i++) {
      secondLine.add(getQuesNavigationIcon(i));
    }
    var thirdLine = new List<Widget>.empty(growable: true);
    for (int i = 20; i < maximum && i < 30; i++) {
      thirdLine.add(getQuesNavigationIcon(i));
    }
    var fourLine = new List<Widget>.empty(growable: true);
    for (int i = 30; i < maximum && i < 40; i++) {
      fourLine.add(getQuesNavigationIcon(i));
    }

    Row row(List<Widget> icons) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: icons,
        );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        row(firstLine),
        row(secondLine),
        row(thirdLine),
        row(fourLine),
      ],
    );
  }

  Widget getQuesNavigationIcon(int index) {
    String path = 'assets/icons/button_quiz_navi_normal.svg';
    if (mode == 0) {
      if (selected[index] > 0) {
        // Selected
        path = 'assets/icons/button_quiz_navi_selected.svg';
      }
    } else if (mode == 1) {
      if (selected[index] == _getCorrectIndex(index)) {
        path = 'assets/icons/button_quiz_navi_correct.svg';
      } else {
        path = 'assets/icons/button_quiz_navi_wrong.svg';
      }
    }

    return IconButton(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      icon: SvgPicture.asset(path),
      iconSize: 25.h,
      constraints: BoxConstraints(minHeight: 16.h, minWidth: 16.w),
      onPressed: () => onSelect?.call(index),
    );
  }
}
