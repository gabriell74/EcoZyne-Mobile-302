class WasteBank {
  final int id;
  final int communityId;
  final String wasteBankName;
  final String wasteBankLocation;
  final String photo;
  final double latitude;
  final double longitude;
  final String fileDocument;
  final String notes;
  final String status;
  final String createdAt;
  final String updatedAt;

  WasteBank({
    required this.id,
    required this.communityId,
    required this.wasteBankName,
    required this.wasteBankLocation,
    required this.photo,
    required this.latitude,
    required this.longitude,
    required this.fileDocument,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WasteBank.fromJson(Map<String, dynamic> json) {
    return WasteBank(
      id: json["id"] ?? 0,
      communityId: json["community_id"] ?? 0,
      wasteBankName: json["waste_bank_name"] ?? "",
      wasteBankLocation: json["waste_bank_location"] ?? "",
      photo: json["photo"] ?? "",
      latitude: double.tryParse(json["latitude"].toString()) ?? 0.0,
      longitude: double.tryParse(json["longitude"].toString()) ?? 0.0,
      fileDocument: json["file_document"] ?? "",
      notes: json["notes"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
}
