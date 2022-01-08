import 'package:sathachlaixe/model/user.dart';
import 'package:sathachlaixe/singleston/appconfig.dart';
import 'package:sathachlaixe/singleston/socketio.dart';

class UserRepos {
  UserModel? get currentUser => AppConfig.instance.userInfo;
  void updateUserInfo(String name, List<int>? rawimage) {
    SocketController.instance.updateUserInfo(name, rawimage);
  }
}
