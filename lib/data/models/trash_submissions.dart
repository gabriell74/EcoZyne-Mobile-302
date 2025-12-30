class TrashSubmissions {
  final int id;
  final int wasteBankId;
  final String wasteBankName;
  final String status;
  final String createdAt;

  TrashSubmissions({
    required this.id,
    required this.wasteBankId,
    required this.wasteBankName,
    required this.status,
    required this.createdAt
  });

  factory TrashSubmissions.fromJson(Map<String, dynamic> json) {
    return TrashSubmissions(
      id: json['id'],
      wasteBankId: json['waste_bank_id'],
      wasteBankName: json['waste_bank_name'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}