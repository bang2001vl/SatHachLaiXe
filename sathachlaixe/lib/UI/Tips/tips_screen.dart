import 'package:sathachlaixe/UI/Component/back_button.dart';
import 'package:sathachlaixe/UI/Style/color.dart';
import 'package:sathachlaixe/UI/Style/text_style.dart';
import 'package:sathachlaixe/UI/Component/return_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sathachlaixe/UI/Tips/practice_page.dart';
import 'package:sathachlaixe/UI/Tips/theory_page.dart';
import 'package:flutter/material.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({Key? key}) : super(key: key);

  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.h,
          backgroundColor: dtcolor1,
          leading: Container(
            margin: EdgeInsets.only(top: 10.h),
            child: BackButtonComponent(),
          ),
          titleSpacing: 20.h,
          centerTitle: true,
          title: Container(
            margin: EdgeInsets.only(top: 10.h),
            child: Text(
              "MẸO THI",
              style: kText20Bold_13,
            ),
          ),
          bottom: TabBar(
            padding: EdgeInsets.only(bottom: 1.h, left: 10.w, right: 10.w),
            controller: _tabController,
            labelStyle: kText20Bold_13,
            indicatorColor: dtcolor13,
            indicatorWeight: 3,
            labelPadding: EdgeInsets.only(
              bottom: 5.h,
            ),
            unselectedLabelStyle: kText20Bold_13,
            tabs: [
              Text(
                "Lý thuyết",
                style: kText18Bold_13,
              ),
              Text(
                "Thực hành",
                style: kText18Bold_13,
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [TheoryPage(), PracticePage()],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
