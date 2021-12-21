import 'package:flutter/material.dart';

Widget buildError(BuildContext context, Object? error) {
  return Center(child: Text("Có lỗi xảy ra"));
}

Widget buildLoading(BuildContext context) {
  return Center(child: Text("Đang tải..."));
}
