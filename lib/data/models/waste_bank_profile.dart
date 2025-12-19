class WasteBankProfile {
  final int id;
  final String wasteBankName;
  final String wasteBankLocation;
  final double latitude;
  final double longitude;

  WasteBankProfile({
    required this.id,
    required this.wasteBankName,
    required this.wasteBankLocation,
    required this.latitude,
    required this.longitude,
  });

  factory WasteBankProfile.fromJson(Map<String, dynamic> json) {
    return WasteBankProfile(
      id: json["id"] ?? '',
      wasteBankName: json['waste_bank_name'] ?? '',
      wasteBankLocation: json['waste_bank_location'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'waste_bank_name': wasteBankName,
      'waste_bank_location': wasteBankLocation,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
