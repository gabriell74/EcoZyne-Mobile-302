class Reward {
  final int id;
  final String rewardName;
  final String photo;
  int stock;
  final int unitPoint;

  Reward({
    required this.id,
    required this.rewardName,
    required this.photo,
    required this.stock,
    required this.unitPoint
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json["id"],
      rewardName: json["reward_name"],
      photo: json["photo"],
      stock: json["stock"],
      unitPoint: json["unit_point"],
    );
  }
}