import 'package:sathachlaixe/model/timestamp.dart';

class PracticeModel extends TimeStampModel {
  int questionID = -1;
  int selectedAnswer = 0;
  int correctAnswer = 0;
  int countWrong = 0;
  int countCorrect = 0;

  PracticeModel(this.questionID, this.selectedAnswer, this.correctAnswer,
      this.countWrong, this.countCorrect);

  PracticeModel.create({
    this.questionID = -1,
    this.selectedAnswer = 0,
    this.correctAnswer = 0,
    this.countWrong = 0,
    this.countCorrect = 0,
  });

  PracticeModel.fromJSON(Map json) {
    this.questionID = json["questionID"];
    this.selectedAnswer = json["selectedAnswer"];
    this.correctAnswer = json["correctAnswer"];
    this.countWrong = json["countWrong"];
    this.countCorrect = json["countCorrect"];

    getTimeStamp(json);
  }

  Map<String, Object> toJSONinsert() {
    return {
      "questionID": this.questionID,
      "selectedAnswer": this.selectedAnswer,
      "correctAnswer": this.correctAnswer,
      "countWrong": this.countWrong,
      "countCorrect": this.countCorrect,
    };
  }
}
