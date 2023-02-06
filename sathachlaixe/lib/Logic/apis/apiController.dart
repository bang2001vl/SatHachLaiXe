import 'package:dio/dio.dart';
import 'package:sathachlaixe/Logic/model/TopicOverviewData.dart';
import 'package:sathachlaixe/singleston/repository.dart';

class ApiController {
  String _token = '';
  String topicType = 'b1';

  //final _serverURL = 'http://192.168.1.111:8080';
  final _serverURL = RepositoryGL.serverURL + ":8080";

  late Dio _dio;

  ApiController({required this.topicType}) {
    _dio = Dio();
  }

  String getTopicOverviewListURL() {
    return '$_serverURL/$topicType/topic_overview_all/';
  }

  Future<TopicOverViewsResponse> getTopicOverviewList() async {
    var params = {
      "apiToken": _token,
    };
    try {
      // Response response =
      //     await _dio.get(getTopicOverviewListURL(), queryParameters: params);
      // return TopicOverViewsResponse.fromJSON(response.data);

      var temp = List.generate(20, (i) => TopicOverview(id: i));
      return TopicOverViewsResponse(temp);
    } catch (err, stackstrace) {
      return TopicOverViewsResponse.withError("Cannot connect to server");
    }
  }
}
