import 'package:ecozyne_mobile/data/models/article.dart';
import 'package:ecozyne_mobile/data/services/article_service.dart';
import 'package:flutter/material.dart';

class ArticleProvider with ChangeNotifier {
  final ArticleService _articleService = ArticleService();

  List<Article> _latestArticles = [];
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  bool _isSearching = false;
  bool _isLoading = false;
  bool _connected = true;
  String _message = "";

  List<Article> get articles => _filteredArticles.isNotEmpty ? _filteredArticles : _articles;
  List<Article> get filteredArticles => _filteredArticles;
  List<Article> get latestArticles => _latestArticles;
  bool get isLoading => _isLoading;
  bool get connected => _connected;
  bool get isSearching => _isSearching;
  String get message => _message;

  Future<void> fetchArticles() async {
    _isLoading = true;
    notifyListeners();

    final result = await _articleService.getArticles();

    _isLoading = false;
    _connected = result["connected"] ?? false;

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

  Future<void> fetchLatestArticles() async {
    _isLoading = true;
    notifyListeners();

    final result = await _articleService.getLatestArticles();

    _isLoading = false;
    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _latestArticles = data;
        _message = "Berhasil mengambil artikel";
      } else {
        _latestArticles = [];
        _message = "Belum ada artikel yang tersedia";
      }
    } else {
      _latestArticles = [];
      _message = result["message"] ?? "Gagal memuat artikel";
    }

    notifyListeners();
  }

  void searchArticles(String query) {
    _isSearching = true;
    if (query.isEmpty) {
      _filteredArticles = [];
      _isSearching = false;
    } else {
      _filteredArticles = _articles
          .where((article) =>
            article.title.toLowerCase().contains(query.toLowerCase()) ||
            article.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _isSearching = false;
    _filteredArticles = [];
    notifyListeners();
  }
}
