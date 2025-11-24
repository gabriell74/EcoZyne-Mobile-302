import 'package:flutter/material.dart';
import '../models/point_income_history.dart';
import '../services/history_service.dart';
import '../../core/utils/history_helper.dart';

class PointIncomeHistoryProvider with ChangeNotifier {
  final HistoryService _historyService = HistoryService();

  PointIncomeHistory? _pointIncomeHistory;
  Map<String, List<Map<String, dynamic>>> _groupedHistory = {};

  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  PointIncomeHistory? get pointIncomeHistory => _pointIncomeHistory;
  Map<String, List<Map<String, dynamic>>> get groupedHistory => _groupedHistory;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

  DateTime? _lastFetchedPointIncome;
  final Duration _cacheDuration = const Duration(minutes: 5);

  Future<void> getPointIncomeHistory({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _pointIncomeHistory != null &&
        _lastFetchedPointIncome != null &&
        DateTime.now().difference(_lastFetchedPointIncome!) < _cacheDuration) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _historyService.fetchPointIncomeHistory();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      _pointIncomeHistory = result["data"] as PointIncomeHistory?;
      _lastFetchedPointIncome = DateTime.now();

      if (_pointIncomeHistory == null ||
          (_pointIncomeHistory!.rejectedReward.isEmpty && _pointIncomeHistory!.wasteSubmission.isEmpty)) {
        _message = "Belum ada riwayat Pemasukan Poin";
        _groupedHistory = {};
      } else {
        _message = result["message"];
        final allItems = [
          ...?_pointIncomeHistory?.rejectedReward.map((e) => {
                "type": "rejectedReward",
                "item": e,
                "date": e.updatedAt,
              }),
          ...?_pointIncomeHistory?.wasteSubmission.map((e) => {
                "type": "wasteSubmission",
                "item": e,
                "date": e.createdAt,
              }),
        ];

        _groupedHistory = groupByDate<Map<String, dynamic>>(
          allItems,
          getDate: (item) => DateTime.parse(item["date"] as String),
        );
      }
    } else {
      _pointIncomeHistory = null;
      _groupedHistory = {};
      _message = result["message"] ?? "Gagal memuat riwayat pemasukan poin";
    }

    _isLoading = false;
    notifyListeners();
  }
}
