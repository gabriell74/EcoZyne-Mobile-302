import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/user.dart';
import 'package:ecozyne_mobile/data/services/secure_storage_service.dart';

class AuthService {
  final _dio = ApiClient.dio;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        final user = User.fromJson(response.data["user"]);
        final token = response.data["token"];

        if (token != null) {
          await SecureStorageService.saveToken(token);
        }

        return {
          "success": true,
          "message": response.data["message"] ?? "Login berhasil",
          "user": user,
        };
      } else {
        return {
          "success": false,
          "message": response.data["message"] ?? "Login gagal",
        };
      }
    } on DioException catch (e) {
      final res = e.response;

      if (res != null && res.data is Map<String, dynamic>) {
        return {
          "success": false,
          "message": res.data["message"] ?? "Terjadi kesalahan saat login",
        };
      } else {
        return {
          "success": false,
          "message": "Tidak ada koneksi",
        };
      }
    } catch (_) {
      return {
        "success": false,
        "message": "Terjadi kesalahan tak terduga",
      };
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

      if (response.statusCode == 201 || response.data["success"] == true) {
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
      final res = e.response;

      if (res?.statusCode == 422) {
        return {
          "success": false,
          "message": res?.data["message"] ?? "Validasi gagal",
          "errors": res?.data["errors"],
        };
      } else if (res != null && res.data is Map<String, dynamic>) {
        return {
          "success": false,
          "message": res.data["message"] ?? "Registrasi gagal",
        };
      } else {
        return {
          "success": false,
          "message": "Tidak ada koneksi",
        };
      }
    } catch (_) {
      return {
        "success": false,
        "message": "Terjadi kesalahan tak terduga",
      };
    }
  }

  Future<void> logout() async {
    await SecureStorageService.deleteToken();
  }
}
