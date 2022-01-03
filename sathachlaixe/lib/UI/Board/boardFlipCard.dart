import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'dart:math';

import 'package:sathachlaixe/model/board.dart'; // it will allows us to get the pi constant

class BoardFlipCard extends StatefulWidget {
  const BoardFlipCard({
    Key? key,
    required this.item,
  }) : super(key: key);
  final BoardModel item;

  @override
  _BoardFlipCardState createState() => _BoardFlipCardState();
}

class _BoardFlipCardState extends State<BoardFlipCard> {
  //declare the isBack bool

  bool isBack = true;
  double angle = 0;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: angle),
          duration: Duration(seconds: 1),
          builder: (BuildContext context, double val, __) {
            //here we will change the isBack val so we can change the content of the card
            if (val >= (pi / 2)) {
              isBack = false;
            } else {
              isBack = true;
            }
            return (Transform(
              //let's make the card flip by it's center
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(val),
              child: Container(
                  child: isBack
                      ? Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                              color: dtcolor13,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5,
                                    color: dtcolor7,
                                    spreadRadius: 0.0,
                                    offset: Offset.zero),
                              ],
                              border: Border.all(width: 1, color: dtcolor7)),
                          child: Image.asset(widget.item.assetURL),
                        ) //if it's back we will display here
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..rotateY(
                                pi), // it will flip horizontally the container
                          child: Container(
                            decoration: BoxDecoration(
                              color: dtcolor17,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 30.h, horizontal: 20.w),
                              child: Column(
                                children: [
                                  Text(widget.item.name, style: kText20Bold_13),
                                  SizedBox(height: 15.h),
                                  Text(
                                    widget.item.detail,
                                    style: kText16Normal_13,
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ) //else we will display it here,
                  ),
            ));
          }),
    );
  }
}
