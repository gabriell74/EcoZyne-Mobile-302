class Address {
  final String address;
  final String postalCode;
  final String kelurahan;
  final String kecamatan;

  Address({
    required this.address,
    required this.postalCode,
    required this.kelurahan,
    required this.kecamatan,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'] ?? '',
      postalCode: json['postal_code'] ?? '',
      kelurahan: json['kelurahan'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'postal_code': postalCode,
      'kelurahan': kelurahan,
      'kecamatan': kecamatan,
    };
  }
}

class CommunityProfile {
  final String name;
  final String phoneNumber;
  final String photo;
  final int point;
  final String expiredPoint;
  final Address address;

  CommunityProfile({
    required this.name,
    required this.phoneNumber,
    required this.photo,
    required this.point,
    required this.expiredPoint,
    required this.address,
  });

  factory CommunityProfile.fromJson(Map<String, dynamic> json) {
    return CommunityProfile(
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      photo: json['photo'] ?? '',
      point: json['point'] ?? 0,
      expiredPoint: json['expired_point'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'photo': photo,
      'point': point,
      'expired_point': expiredPoint,
      'address': address.toJson(),
    };
  }
}
