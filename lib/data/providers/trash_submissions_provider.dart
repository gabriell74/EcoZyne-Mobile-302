import 'package:ecozyne_mobile/data/models/trash_submissions.dart';
import 'package:ecozyne_mobile/data/services/history_service.dart';
import 'package:flutter/material.dart';

class TrashSubmissionsProvider with ChangeNotifier {
  final HistoryService _historyService = HistoryService();

  List<TrashSubmissions> _trashSubmissions = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  List<TrashSubmissions> get trashSubmissions => _trashSubmissions;

  bool get isLoading => _isLoading;

  String get message => _message;

  bool get connected => _connected;

  Future<void> getTrashSubmissionsHistory() async {
    _isLoading = true;
    notifyListeners();

    final result = await _historyService.fetchTrashSubmissionsHistory();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data.isNotEmpty) {
        _trashSubmissions = data;
        _message = result["message"] ?? "";
      } else {
        _trashSubmissions = [];
        _message = "Belum ada pengajuan setoran sampah";
      }
    } else {
      _trashSubmissions = [];
      _message = result["message"] ?? "Gagal memuat pengajuan setoran sampah";
    }

    _isLoading = false;
    notifyListeners();
  }
}