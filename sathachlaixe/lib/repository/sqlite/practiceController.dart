import 'package:flutter/foundation.dart';
import 'package:sathachlaixe/model/practice.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';

class PracticeController {
  final String tableName = 'practice';
  PracticeController();

  Future<int> insert(Practice data) async {
    var db = await AppConfig().openDB();
    var values = data.toJSON_insert();
    values["create_time"] = DateTime.now().toUtc().millisecondsSinceEpoch;
    return db.insert(tableName, values);
  }
}
