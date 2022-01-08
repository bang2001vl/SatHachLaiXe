import 'dart:developer';

import 'package:sathachlaixe/singleston/repository.dart';
import 'package:sathachlaixe/singleston/socketio.dart';

class DataRepo {
  Future<int> deleteData() async {
    log("Delete data local");
    repository.deleteAllLocalData();

    log("Delete data sync");
    if (!repository.isSyncON) {
      return 0;
    }

    if (!repository.isAuthorized) {
      var rs = await repository.auth.autoLogin();
      if (rs != 1) {
        return 0;
      }
    }
    return SocketController.instance.deleteData();
  }
}
