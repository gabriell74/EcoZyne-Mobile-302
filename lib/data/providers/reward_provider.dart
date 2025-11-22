import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/reward.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/data/services/reward_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RewardProvider with ChangeNotifier {
  final RewardService _rewardService = RewardService();
  final Dio _dio = ApiClient.dio;

  List<Reward> _rewards = [];
  Reward? _rewardDetail;

  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  DateTime? _lastFetchedRewards;
  final Duration _cacheDuration = const Duration(minutes: 5);

  final Duration _stockCacheDuration = const Duration(seconds: 30);
  final Map<int, DateTime> _stockCacheTime = {};

  List<Reward> get rewards => _rewards;
  Reward? get rewardDetail => _rewardDetail;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

  Future<void> getRewards({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _rewards.isNotEmpty &&
        _lastFetchedRewards != null &&
        DateTime.now().difference(_lastFetchedRewards!) < _cacheDuration) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _rewardService.fetchRewards();
    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _rewards = data;
        _message = result["message"];
        _lastFetchedRewards = DateTime.now();
      } else {
        _rewards = [];
        _message = "Hadiah belum tersedia";
      }
    } else {
      _rewards = [];
      _message = result["message"] ?? "Gagal memuat hadiah";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> rewardExchange(
      int amount,
      int rewardId,
      int totalPoint,
      UserProvider userProvider,
      ) async {
    _isLoading = true;
    notifyListeners();

    final originalPoint = userProvider.user?.communityPoint ?? 0;
    userProvider.updateCommunityPoint(originalPoint - totalPoint);

    final result = await _rewardService.rewardExchangeTransaction(
      amount,
      rewardId,
      totalPoint,
    );

    _connected = result["connected"] ?? false;
    _message = result["message"] ?? "Terjadi kesalahan";
    final bool success = result["success"] ?? false;

    if (!success) {
      userProvider.updateCommunityPoint(originalPoint);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> updateRewardStock(int rewardId) async {
    final lastTime = _stockCacheTime[rewardId];
    if (lastTime != null && DateTime.now().difference(lastTime) < _stockCacheDuration) {
      return;
    }

    try {
      final response = await _dio.get("/rewards/$rewardId");
      _connected = true;

      if (response.statusCode == 200 && response.data["success"] == true) {
        final data = response.data["data"];
        if (data != null) {
          final index = _rewards.indexWhere((r) => r.id == rewardId);
          if (index != -1) {
            _rewards[index].stock = data["stock"];
          }

          if (_rewardDetail != null && _rewardDetail!.id == rewardId) {
            _rewardDetail!.stock = data["stock"];
          }

          _stockCacheTime[rewardId] = DateTime.now();
          notifyListeners();
        }
      }
    } catch (e) {
      _connected = false;
    }
  }
}
