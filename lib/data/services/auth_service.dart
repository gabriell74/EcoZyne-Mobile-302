import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
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
        final token = response.data["token"];

        if (token != null) {
          await SecureStorageService.saveToken(token);
        }

        return {
          "success": true,
          "message": response.data["message"] ?? "Login berhasil",
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
    required String email,
    required String password,
    required String role,
    required String name,
    required String phoneNumber,
    required String address,
    required String postalCode,
    required int kecamatanId,
    required int kelurahanId,
  }) async {
    try {
      final data = {
        'username': username,
        'email': email,
        'password': password,
        'role': role,
        'name': name,
        'phone_number': phoneNumber,
        'address': address,
        'postal_code': postalCode,
        'kecamatan_id': kecamatanId,
        'kelurahan': kelurahanId,
      };

      final response = await _dio.post('/register', data: data);

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

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '/register/verify-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 201 || response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'],
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Verifikasi gagal',
      };
    } on DioException catch (e) {
      final res = e.response;

      if (res?.statusCode == 429) {
        return {
          'success': false,
          'message':
          res?.data['message'] ??
              'Terlalu banyak percobaan OTP. Silakan coba lagi nanti.',
        };
      }

      if (res != null && res.data is Map<String, dynamic>) {
        return {
          'success': false,
          'message': res.data['message'] ?? 'Verifikasi gagal',
        };
      }

      return {
        'success': false,
        'message': 'Tidak ada koneksi',
      };
    }
  }

  Future<Map<String, dynamic>> resendOtp({
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        '/register/resend-otp',
        data: {
          'email': email,
        },
      );

      if (response.statusCode == 200 || response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'],
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Gagal mengirim ulang OTP',
      };
    } on DioException catch (e) {
      final res = e.response;

      if (res?.statusCode == 429) {
        return {
          'success': false,
          'message':
          res?.data['message'] ??
              'Terlalu banyak permintaan OTP. Silakan coba lagi nanti.',
          'rate_limited': true,
        };
      }

      if (res != null && res.data is Map<String, dynamic>) {
        return {
          'success': false,
          'message': res.data['message'] ?? 'Gagal mengirim ulang OTP',
        };
      }

      return {
        'success': false,
        'message': 'Tidak ada koneksi',
      };
    }
  }


  Future<void> logout() async {
    await SecureStorageService.deleteToken();
  }
}
