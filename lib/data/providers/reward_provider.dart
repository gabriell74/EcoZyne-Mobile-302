import 'package:ecozyne_mobile/data/models/reward.dart';
import 'package:ecozyne_mobile/data/services/reward_service.dart';
import 'package:flutter/material.dart';

class RewardProvider with ChangeNotifier {
  final RewardService _rewardService = RewardService();

  List<Reward> _rewards = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  List<Reward> get rewards => _rewards;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

 Future<void> getRewards() async {
    _isLoading = true;
    notifyListeners();

    final result = await _rewardService.fetchRewards();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _rewards = data;
        _message = result["message"];
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
 
  
  }
