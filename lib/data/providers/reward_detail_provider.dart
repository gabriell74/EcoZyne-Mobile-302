import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/data/models/reward.dart';
import 'package:ecozyne_mobile/data/services/reward_service.dart';

class RewardDetailProvider with ChangeNotifier {
  final RewardService _rewardService = RewardService();

  Reward? _rewardDetail;
  Reward? get rewardDetail => _rewardDetail;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _connected = true;
  bool get connected => _connected;

  String _message = "";
  String get message => _message;

  final Map<int, Reward> _rewardCache = {};
  final Map<int, DateTime> _rewardCacheTime = {};

  final Duration _cacheDuration = const Duration(minutes: 5);

  Future<void> getRewardById(int rewardId) async {
    if (_rewardCache.containsKey(rewardId)) {
      final lastTime = _rewardCacheTime[rewardId]!;
      final diff = DateTime.now().difference(lastTime);

      if (diff < _cacheDuration) {
        _rewardDetail = _rewardCache[rewardId];
        _message = "Data dari cache";
        notifyListeners();
        return;
      }
    }

    _isLoading = true;
    notifyListeners();

    final result = await _rewardService.fetchRewardById(rewardId);
    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];

      if (data != null) {
        _rewardDetail = data;
        _message = "Berhasil mendapatkan data hadiah";

        _rewardCache[rewardId] = data;
        _rewardCacheTime[rewardId] = DateTime.now();
      } else {
        _rewardDetail = null;
        _message = "Hadiah tidak ditemukan";
      }
    } else {
      _rewardDetail = null;
      _message = result["message"] ?? "Gagal memuat hadiah";
    }

    _isLoading = false;
    notifyListeners();
  }
}
