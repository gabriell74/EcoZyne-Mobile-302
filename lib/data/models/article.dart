class Article {
  final int id;
  final String title;
  final String photo;
  final String description;
  final String created_at;

  Article({
    required this.id,
    required this.title,
    required this.photo,
    required this.description,
    required this.created_at
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      photo: json['photo'],
      description: json['description'],
      created_at: json['created_at'],
    );
  }
}