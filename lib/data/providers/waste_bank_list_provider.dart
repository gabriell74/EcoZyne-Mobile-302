import 'package:ecozyne_mobile/data/models/waste_bank_submission.dart';
import 'package:ecozyne_mobile/data/services/waste_bank_list_service.dart';
import 'package:flutter/material.dart';

class WasteBankListProvider with ChangeNotifier {
  final WasteBankListService _wasteBankListService = WasteBankListService();

  List<WasteBankSubmission> _wasteBanks = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  List<WasteBankSubmission> get wasteBanks => _wasteBanks;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

  Future<void> getWasteBankList() async {
    _isLoading = true;
    notifyListeners();

    final result = await _wasteBankListService.fetchWasteBankList();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _wasteBanks = data;
        _message = result["message"];
      } else {
        _wasteBanks = [];
        _message = "Belum ada bank sampah yang tersedia";
      }
    } else {
      _wasteBanks = [];
      _message = result["message"] ?? "Gagal memuat bank sampah";
    }

    _isLoading = false;
    notifyListeners();
  }
}
