import 'package:expandable/expandable.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TipItem extends StatelessWidget {
  const TipItem({
    Key? key,
    required this.detail,
    required this.title,
    required this.content,
    required this.count,
    required this.imageSrc,
  }) : super(key: key);
  final String title, detail, imageSrc;
  final List<String> content;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ExpandablePanel(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 100.h,
              width: 100.h,
              decoration: BoxDecoration(
                color: dtcolor8,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(imageSrc),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: kText16Medium_14,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(detail, style: kText14Normal_14),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text('${count} mẹo', style: kText14Normal_11),
                ],
              ),
            ),
          ],
        ),
        expanded: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          color: dtcolor8,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: content.length,
              itemBuilder: (context, index) {
                if (content.length == 1) {
                  return Text(
                    "${content[0]}",
                    style: kText14Normal_6,
                    softWrap: true,
                  );
                } else
                  return buildItem(context, content[index], index);
              }),
        ),
        collapsed: SizedBox(
          height: 5.h,
        ),
      ),
    );
  }
}

Widget buildItem(BuildContext context, String content, int index) {
  {
    return Text(
      "${index + 1}. ${content}",
      style: kText14Normal_6,
      softWrap: true,
    );
  }
}
