import 'package:sathachlaixe/singleston/repository.dart';

class QuestionStatistic {
  String questionId;
  int countCorrect;
  int countWrong;

  QuestionStatistic({
    required this.questionId,
    required this.countCorrect,
    required this.countWrong,
  });

  factory QuestionStatistic.fromJSON(Map json) {
    return QuestionStatistic(
      questionId: json["questionId"],
      countCorrect: json["countCorrect"],
      countWrong: json["countWrong"],
    );
  }

  String getCateName() {
    return repository
        .getQuestionCategory()
        .where((element) => element.questionIDs.contains(this.questionId))
        .first
        .name;
  }
}
