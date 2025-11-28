class ComicDetail {
  final int comicId;
  final List<String> photos;

  ComicDetail({
    required this.comicId,
    required this.photos,
  });

  factory ComicDetail.fromJson(Map<String, dynamic> json) {
    return ComicDetail(
      comicId: int.parse(json["comic_id"].toString()),
      photos: List<String>.from(json["photos"].map((x) => x)),
    );
  }
}

class Comic {
  final int id;
  final String title;
  final String coverPhoto;
  final String createdAt;
  final String updatedAt;

  Comic({
    required this.id,
    required this.title,
    required this.coverPhoto,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      coverPhoto: json["cover_photo"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
}