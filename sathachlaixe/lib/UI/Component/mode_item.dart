import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class CustomRadio extends StatefulWidget {
  @override
  createState() {
    return new CustomRadioState();
  }
}

class CustomRadioState extends State<CustomRadio> {
  List<RadioModel> modeData = [];
  late String selectedValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modeData.add(new RadioModel(repository.getCurrentMode() == 'b1', 'Hạng B1',
        'Ô tô tải trọng lượng dưới 3500kg'));
    modeData.add(new RadioModel(repository.getCurrentMode() == 'b2', 'Hạng B2',
        'Ô tô chở người đến 9 chỗ'));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: modeData.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            setState(() {
              modeData.forEach((element) => element.isSelected = false);
              modeData[index].isSelected = true;
              index == 0 ? selectedValue = 'b1' : selectedValue = 'b2';
              repository.updateMode(selectedValue);
            });
          },
          child: RadioItem(modeData[index]),
        );
      },
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: dtcolor7, width: 0.5),
          borderRadius: BorderRadius.circular(15),
          color: dtcolor13),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _item.mode,
                  style: kText16Medium_14,
                ),
                SizedBox(height: 10.h),
                Text(
                  _item.subtitle,
                  style: kText16Normal_11,
                ),
              ],
            ),
          ),
          Container(
              width: 30.h,
              height: 30.h,
              child: _item.isSelected
                  ? SvgPicture.asset('assets/icons/quiz_check_correct.svg')
                  : SizedBox()),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String mode;
  final String subtitle;

  RadioModel(this.isSelected, this.mode, this.subtitle);
}
