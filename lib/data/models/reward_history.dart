class RewardHistory {
  final int id;
  final String rewardName;
  final String? photo;

  RewardHistory({
    required this.id,
    required this.rewardName,
    this.photo,
  });

  factory RewardHistory.fromJson(Map<String, dynamic> json) {
    return RewardHistory(
      id: json["id"],
      rewardName: json["reward_name"],
      photo: json["photo"] ?? "",
    );
  }
}
