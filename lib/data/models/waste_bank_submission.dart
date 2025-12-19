class WasteBankSubmission {
  final String wasteBankName;
  final String wasteBankLocation; // Sudah berisi semua: alamat, RT/RW, kelurahan, kecamatan, kode pos, kota, provinsi
  final String photoPath;
  final double latitude;
  final double longitude;
  final String fileDocumentPath;
  final String notes; // Ini dari descriptionController

  WasteBankSubmission({
    required this.wasteBankName,
    required this.wasteBankLocation,
    required this.photoPath,
    required this.latitude,
    required this.longitude,
    required this.fileDocumentPath,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      "waste_bank_name": wasteBankName,
      "waste_bank_location": wasteBankLocation,
      "photo": photoPath,
      "latitude": latitude,
      "longitude": longitude,
      "file_document": fileDocumentPath,
      "notes": notes,
      "status": "pending",
    };
  }
}