import 'package:ecozyne_mobile/data/models/reward_history.dart';

class ExchangeTransactionHistory {
  final int id;
  final int amount;
  final int totalUnitPoint;
  final RewardHistory reward;

  ExchangeTransactionHistory({
    required this.id,
    required this.amount,
    required this.totalUnitPoint,
    required this.reward,
  });

  factory ExchangeTransactionHistory.fromJson(Map<String, dynamic> json) {
    return ExchangeTransactionHistory(
      id: json["id"],
      amount: json["amount"],
      totalUnitPoint: json["total_unit_point"],
      reward: RewardHistory.fromJson(json["reward"]),
    );
  }
}
