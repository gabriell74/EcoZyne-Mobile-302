class RewardHistory {
  final int id;
  final String rewardName;

  RewardHistory({
    required this.id,
    required this.rewardName,
  });

  factory RewardHistory.fromJson(Map<String, dynamic> json) {
    return RewardHistory(
      id: json["id"],
      rewardName: json["reward_name"],
    );
  }
}
