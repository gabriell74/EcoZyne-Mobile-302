class Article {
  final int id;
  final String title;
  final String image;
  final String description;

  Article({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      description: json['description']
    );
  }
}