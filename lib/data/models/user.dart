import 'package:ecozyne_mobile/data/models/community_profile.dart';
import 'package:ecozyne_mobile/data/models/waste_bank_profile.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String role;
  final CommunityProfile community;
  final WasteBankProfile? wasteBank;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.community,
    this.wasteBank,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      community:CommunityProfile.fromJson(json['community']),
      wasteBank: json['waste_bank'] != null
          ? WasteBankProfile.fromJson(json['waste_bank'])
          : null,
    );
  }

  String get communityName => community.name;
  String get communityPhone => community.phoneNumber;
  String get communityAddress => community.address.address;
  String get communityPostalCode => community.address.postalCode;
  String get communityKelurahan => community.address.kelurahan;
  String get communityKecamatan => community.address.kecamatan;
  String get communityPhoto => community.photo;
  int get communityPoint => community.point;
  String get communityExpiredPoint => community.expiredPoint;

  String? get wasteBankName => wasteBank?.wasteBankName;
  String? get wasteBankLocation => wasteBank?.wasteBankLocation;
  double? get latitude => wasteBank?.latitude;
  double? get longitude => wasteBank?.longitude;

  Map<String, dynamic> toJson({
    required String name,
    required String phoneNumber,
    required String address,
    required String postalCode,
    required int kelurahanId,
    required String password,
  }) {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'name': name,
      'phone_number': phoneNumber,
      'address': address,
      'postal_code': postalCode,
      'kelurahan': kelurahanId,
    };
  }
}