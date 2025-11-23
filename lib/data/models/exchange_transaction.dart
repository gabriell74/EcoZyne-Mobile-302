import 'package:ecozyne_mobile/data/models/reward.dart';

class ExchangeTransaction {
  final int id;
  final int exchangeId;
  final int rewardId;
  final int amount;
  final int totalUnitPoint;
  final Reward reward;

  ExchangeTransaction({
    required this.id,
    required this.exchangeId,
    required this.rewardId,
    required this.amount,
    required this.totalUnitPoint,
    required this.reward,
  });

  factory ExchangeTransaction.fromJson(Map<String, dynamic> json) {
    return ExchangeTransaction(
      id: json["id"],
      exchangeId: json["exchange_id"],
      rewardId: json["reward_id"],
      amount: json["amount"],
      totalUnitPoint: json["total_unit_point"],
      reward: Reward.fromJson(json["reward"]),
    );
  }
}
