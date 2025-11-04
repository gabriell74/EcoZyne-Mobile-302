class User {
  final int id;
  final String username;
  final String email;
  final String role;
  final String? name;
  final String? phoneNumber;
  final String? address;
  final String? postalCode;
  final String? kelurahan;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.postalCode,
    required this.kelurahan,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'] ?? '',
      name: json['name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      postalCode: json['postal_code'],
      kelurahan: json['kelurahan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'name': name,
      'phone_number': phoneNumber,
      'address': address,
      'postal_code': postalCode,
      'kelurahan': kelurahan,
    };
  }
}
