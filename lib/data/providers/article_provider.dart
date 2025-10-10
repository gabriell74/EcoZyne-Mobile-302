import 'package:ecozyne_mobile/data/models/article.dart';
import 'package:ecozyne_mobile/data/services/article_service.dart';
import 'package:flutter/material.dart';

class ArticleProvider with ChangeNotifier {
  final ArticleService _articleService = ArticleService();

  List<Article> _articles = [];
  bool _isLoading = false;
  String _message = "";

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String get message => _message;

  Future<void> fetchArticles() async {
    _isLoading = true;
    notifyListeners();

    final result = await _articleService.getArticles();

    _isLoading = false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _articles = data;
        _message = "Berhasil mengambil artikel";
      } else {
        _articles = [];
        _message = "Belum ada artikel yang tersedia";
      }
    } else {
      _articles = [];
      _message = result["message"] ?? "Gagal memuat artikel";
    }

    notifyListeners();
  }
}