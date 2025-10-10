class Article {
  final int id;
  final String title;
  final String photo;
  final String description;

  Article({
    required this.id,
    required this.title,
    required this.photo,
    required this.description,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      photo: json['photo'],
      description: json['description']
    );
  }
}