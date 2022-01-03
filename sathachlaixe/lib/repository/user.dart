import 'package:sathachlaixe/singleston/socketio.dart';

class UserRepos {
  void updateUserInfo(String name, List<int>? rawimage) {
    SocketController.instance.updateUserInfo(name, rawimage);
  }
}
