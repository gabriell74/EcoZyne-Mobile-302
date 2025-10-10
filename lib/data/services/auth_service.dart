import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/user.dart';

class AuthService {
  final _dio = ApiClient.dio;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        final User user = User.fromJson(response.data["user"]);
        return {
          "success": true,
          "message": response.data["message"],
          "user": user,
        };
      } else {
        return {
          "success": false,
          "message": response.data["message"] ?? "Login gagal",
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response?.data;
        return {
          "success": false,
          "message": data["message"] ?? "Login gagal",
        };
      } else {
        return {"success": false, "message": "Tidak ada koneksi ke server"};
      }
    }
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
    required String postalCode,
    required int kecamatanId,
    required int kelurahanId,
  }) async {
    try {
      final response = await _dio.post('/register', data: {
        'username': username,
        'name': name,
        'email': email,
        'password': password,
        'phone_number': phoneNumber,
        'address': address,
        'postal_code': postalCode,
        'kecamatan': kecamatanId,
        'kelurahan': kelurahanId,
      });

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": response.data["message"] ?? "Registrasi berhasil",
        };
      } else {
        return {
          "success": false,
          "message": response.data["message"] ?? "Registrasi gagal",
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Validasi gagal",
          "errors": e.response?.data["errors"],
        };
      } else {
        return {"success": false, "message": "Tidak ada koneksi ke server"};
      }
    }
  }
}
