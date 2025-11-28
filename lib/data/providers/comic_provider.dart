import 'package:ecozyne_mobile/data/models/comic.dart';
import 'package:ecozyne_mobile/data/services/comic_service.dart';
import 'package:flutter/material.dart';

class ComicProvider with ChangeNotifier {
  final ComicService _comicService = ComicService();

  List<Comic> _comics = [];
  bool _isLoadingList = false;
  String _messageList = "";
  bool _connectedList = true;

  List<Comic> get comics => _comics;
  bool get isLoadingList => _isLoadingList;
  String get messageList => _messageList;
  bool get connectedList => _connectedList;

  ComicDetail? _comicDetail;
  bool _isLoadingDetail = false;
  String _messageDetail = "";
  bool _connectedDetail = true;

  ComicDetail? get comicDetail => _comicDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String get messageDetail => _messageDetail;
  bool get connectedDetail => _connectedDetail;

  Future<void> getComics() async {
    _isLoadingList = true;
    notifyListeners();

    final result = await _comicService.fetchComics();
    _connectedList = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _comics = data;
        _messageList = result["message"];
      } else {
        _comics = [];
        _messageList = "Belum ada komik tersedia";
      }
    } else {
      _comics = [];
      _messageList = result["message"] ?? "Gagal memuat komik";
    }

    _isLoadingList = false;
    notifyListeners();
  }

  Future<void> getComicDetail(int comicId) async {
    _isLoadingDetail = true;
    notifyListeners();

    final result = await _comicService.fetchComicDetail(comicId);
    _connectedDetail = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null) {
        _comicDetail = data;
        _messageDetail = result["message"];
      } else {
        _comicDetail = null;
        _messageDetail = "Detail komik tidak ditemukan";
      }
    } else {
      _comicDetail = null;
      _messageDetail = result["message"] ?? "Gagal memuat detail komik";
    }

    _isLoadingDetail = false;
    notifyListeners();
  }
}
