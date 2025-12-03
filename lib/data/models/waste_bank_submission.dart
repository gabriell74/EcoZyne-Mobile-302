class WasteBankSubmission {
  final int wasteBankSubmissionId;
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

  WasteBankSubmission({
    required this.wasteBankSubmissionId,
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

  factory WasteBankSubmission.fromJson(Map<String,dynamic> json) {
    return WasteBankSubmission(
      wasteBankSubmissionId: json["id"] ?? '',
      communityId: json["community_id"] ?? '',
      wasteBankName: json["waste_bank_name"] ?? '',
      wasteBankLocation: json["waste_bank_location"] ?? '',
      photo: json["photo"] ?? '',
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
      fileDocument: json["file_document"] ?? '',
      notes: json["notes"] ?? '',
      status: json["status"] ?? '',
      createdAt: json["created_at"] ?? '',
      updatedAt: json["updated_at"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "waste_bank_name": wasteBankName,
      "waste_bank_location": wasteBankLocation,
      "photo": photo,
      "latitude": latitude,
      "longitude": longitude,
      "file_document": fileDocument,
      "notes": notes,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

}