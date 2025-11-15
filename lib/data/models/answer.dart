class Answer {
  final int id;
  final int questionId;
  final int userId;
  final String answer;
  final String username;

  Answer({
    required this.id,
    required this.questionId,
    required this.userId,
    required this.answer,
    required this.username,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json["id"] ?? 0,
      questionId: int.tryParse(json["question_id"].toString()) ?? 0,
      userId: int.tryParse(json["user_id"].toString()) ?? 0,
      answer: json["answer"] ?? "",
      username: json["user"] != null ? json["user"]["username"] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question_id": questionId,
      "user_id": userId,
      "answer": answer,
    };
  }
}
