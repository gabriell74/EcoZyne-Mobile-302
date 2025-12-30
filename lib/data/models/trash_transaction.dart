class TrashTransaction {
  final int id;
  final String status;
  final int? trashWeight;
  final int? pointEarned;
  final String? trashImage;
  final String? rejectionReason;
  final String createdAt;

  final int userId;
  final String? username;
  final String? communityName;
  final String? phoneNumber;
  final String? wasteBankName;

  TrashTransaction({
    required this.id,
    required this.status,
    required this.trashWeight,
    required this.pointEarned,
    required this.trashImage,
    required this.rejectionReason,
    required this.createdAt,
    required this.userId,
    required this.username,
    required this.communityName,
    required this.phoneNumber,
    required this.wasteBankName,
  });

  factory TrashTransaction.fromJson(Map<String, dynamic> json) {
    return TrashTransaction(
      id: json['id'],
      status: json['status'],
      trashWeight: json['trash_weight'],
      pointEarned: json['point_earned'],
      trashImage: json['trash_image'],
      rejectionReason: json['rejection_reason'],
      createdAt: json['created_at'],

      userId: json['user_id'],
      username: json['username'],
      communityName: json['community_name'],
      phoneNumber: json['phone_number'],
      wasteBankName: json['waste_bank_name']
    );
  }
}
