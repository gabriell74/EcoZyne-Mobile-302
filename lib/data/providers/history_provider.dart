import 'package:ecozyne_mobile/data/models/exchange_history.dart';
import 'package:ecozyne_mobile/data/services/history_service.dart';
import 'package:flutter/material.dart';

class HistoryProvider with ChangeNotifier {
  final HistoryService _historyService = HistoryService();

  List<ExchangeHistory> _exchangeHistory = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  List<ExchangeHistory> get exchangeHistory => _exchangeHistory;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

  DateTime? _lastFetchedExchangeHistory;
  final Duration _cacheDuration = const Duration(minutes: 5);

  Future<void> getRewardExchangeHistory({forceRefresh = false}) async {
    if (!forceRefresh &&
        _exchangeHistory.isNotEmpty &&
        _lastFetchedExchangeHistory != null &&
        DateTime.now().difference(_lastFetchedExchangeHistory!) < _cacheDuration) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _historyService.fetchRewardExchangeHistory();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data.isNotEmpty) {
        _exchangeHistory = data;
        _message = result["message"];
        _lastFetchedExchangeHistory = DateTime.now();
      } else {
        _exchangeHistory = [];
        _message = "Belum ada riwayat penukaran hadiah";
      }
    } else {
      _exchangeHistory = [];
      _message = result["message"] ?? "Gagal memuat riwayat penukaran hadiah";
    }

    _isLoading = false;
    notifyListeners();
  }

}