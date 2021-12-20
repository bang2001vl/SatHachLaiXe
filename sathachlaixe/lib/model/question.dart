class QuestionModel {
  int id;
  String question;
  String imageurl;
  int correct;
  List<String> answers = List.empty();

  QuestionModel(
      this.id, this.question, this.imageurl, this.correct, this.answers);

  QuestionModel.flutter({
    required this.id,
    required this.question,
    required this.correct,
    required this.answers,
    this.imageurl = "",
  });

  Map<String, dynamic> toMap() {
    return Map.of({
      'id': id,
      'question': question,
      'imageurl': imageurl,
      'correct': correct,
      'answer1': answers[0],
      'answer2': answers[1],
      'answer3': answers[2],
      'answer4': answers[3]
    });
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    var answers = List<String>.from({
      map['answer1'],
      map['answer2'],
      map['answer3'],
      map['answer4'],
    });
    if (answers.length > 3 && answers[3] == "") answers.removeAt(3);
    if (answers.length > 2 && answers[2] == "") answers.removeAt(2);
    return new QuestionModel(
      map['id'] as int,
      map['question'] as String,
      map['imageurl'] as String,
      map['correct'] as int,
      answers,
    );
  }

  factory QuestionModel.getMock() {
    return new QuestionModel(
      301,
      "Khi động cơ ô tô đã khởi động, bảng đồng hồ xuất hiện ký hiệu như hình vẽ dưới đây không tắt trong thời gian dài, báo hiệu tình trạng như thế nào của xe ô tô?",
      "https://i-vnexpress.vnecdn.net/2020/09/04/q301.png",
      4,
      List<String>.from({
        "Nhiệt độ nước làm mát động cơ quá ngưỡng cho phép.",
        "Áp suất lốp không đủ.",
        "Đang hãm phanh tay.",
        "Hệ thống lái gặp trục trặc.",
      }),
    );
  }

  QuestionModel.from({
    required this.id,
    required this.question,
    required this.imageurl,
    required this.correct,
    required this.answers,
  });
}
