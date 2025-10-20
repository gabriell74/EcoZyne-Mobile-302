class Question {
  final int id;
  final int userId;
  String question;
  int totalLike;
  int totalComment;
  bool isLiked;
  final String username;

  Question({
    required this.id,
    required this.userId,
    required this.question,
    required this.totalLike,
    required this.totalComment,
    required this.isLiked,
    required this.username,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      userId: json['user_id'],
      question: json['question'] ?? '',
      totalLike: json['total_like'] ?? 0,
      totalComment: json['total_comment'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      username: json['user']?['username'] ?? 'Anonim',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
    };
  }
}
