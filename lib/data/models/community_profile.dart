class Address {
  final String address;
  final String postalCode;
  final int kelurahan;

  Address({
    required this.address,
    required this.postalCode,
    required this.kelurahan,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'] ?? '',
      postalCode: json['postal_code'] ?? '',
      kelurahan: json['kelurahan'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'postal_code': postalCode,
      'kelurahan': kelurahan,
    };
  }
}

class CommunityProfile {
  final int id;
  final int userId;
  final String photo;
  final String phoneNumber;
  final String name;
  final Address address;

  CommunityProfile({
    required this.id,
    required this.userId,
    required this.photo,
    required this.phoneNumber,
    required this.name,
    required this.address,
  });

  factory CommunityProfile.fromJson(Map<String, dynamic> json) {
    return CommunityProfile(
      id: json['id'],
      userId: json['user_id'],
      photo: json['photo'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      name: json['name'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'photo': photo,
      'phone_number': phoneNumber,
      'name': name,
      'address': address.toJson(),
    };
  }
}
