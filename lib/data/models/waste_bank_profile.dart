class WasteBankProfile {
  final int id;
  final int communityId;
  final String communityName;
  final String communityPhone;
  final String address;
  final String postalCode;
  final String name;
  final String location;
  final String latitude;
  final String longitude;

  String? notes;
  String? fileDocument;

  WasteBankProfile({
    required this.id,
    required this.communityId,
    required this.communityName,
    required this.communityPhone,
    required this.address,
    required this.postalCode,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.notes,
    this.fileDocument,
  });

  factory WasteBankProfile.fromJson(Map<String, dynamic> json) {
    return WasteBankProfile(
      id: json['id'],
      communityId: json['community_id'],
      communityName: json['community']['name'],
      communityPhone: json['community']['phone_number'],
      address: json['community']['address']['address'],
      postalCode: json['community']['address']['postal_code'],
      name: json['waste_bank_name'],
      location: json['waste_bank_location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'community_id': communityId,
      'waste_bank_name': name,
      'waste_bank_location': location,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'file_document': fileDocument,
    };
  }
}
