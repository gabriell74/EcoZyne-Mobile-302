class User {
  final int id;
  final String username;
  final String email;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'] ?? '',
    );
  }

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
