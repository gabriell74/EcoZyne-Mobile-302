import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';

class ForgotPasswordService {
  final _dio = ApiClient.dio;

  Future<Map<String, dynamic>> sendResetPasswordOtp({
    required String email,
  }) async {
    try {
      final data = {
        'email': email,
      };

      final response = await _dio.post(
        '/reset-password/send-otp',
        data: data,
      );

      if (response.statusCode == 200 || response.data["success"] == true) {
        return {
          "success": true,
          "message":
          response.data["message"] ?? "OTP berhasil dikirim",
          "email": response.data["email"],
        };
      } else {
        return {
          "success": false,
          "message":
          response.data["message"] ?? "Gagal mengirim OTP",
        };
      }
    } on DioException catch (e) {
      final res = e.response;

      if (res?.statusCode == 422) {
        return {
          "success": false,
          "message": "Validasi gagal",
          "errors": res?.data["errors"],
        };
      } else if (res?.statusCode == 404) {
        return {
          "success": false,
          "message":
          res?.data["message"] ??
              "Email tidak ditemukan atau belum diverifikasi",
        };
      } else if (res != null && res.data is Map<String, dynamic>) {
        return {
          "success": false,
          "message":
          res.data["message"] ?? "Gagal mengirim OTP",
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

  Future<Map<String, dynamic>> verifyResetPasswordOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '/reset-password/verify-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 200 ||
          response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'],
        };
      }

      return {
        'success': false,
        'message':
        response.data['message'] ?? 'Verifikasi OTP gagal',
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
          'message':
          res.data['message'] ?? 'Verifikasi OTP gagal',
        };
      }

      return {
        'success': false,
        'message': 'Tidak ada koneksi',
      };
    }
  }

  Future<Map<String, dynamic>> resendResetPasswordOtp({
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        '/reset-password/resend-otp',
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
        'message':
        response.data['message'] ?? 'Gagal mengirim ulang OTP',
      };
    } on DioException catch (e) {
      final res = e.response;

      if (res?.statusCode == 429) {
        return {
          'success': false,
          'message': res?.data['message'] ??
              'Terlalu banyak permintaan OTP. Silakan coba lagi nanti.',
          'rate_limited': true,
        };
      }

      if (res != null && res.data is Map<String, dynamic>) {
        return {
          'success': false,
          'message':
          res.data['message'] ?? 'Gagal mengirim ulang OTP',
        };
      }

      return {
        'success': false,
        'message': 'Tidak ada koneksi',
      };
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.put(
        '/reset-password',
        data: {
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final success = response.data['success'] == true;

      if (response.statusCode == 200 && success) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Password berhasil direset',
          'connected': true,
        };
      }

      return {
        'success': false,
        'message':
        response.data['message'] ?? 'Gagal mereset password',
        'connected': true,
      };
    } on DioException catch (e) {
      final res = e.response;

      if (res != null) {
        return {
          'success': false,
          'message':
          res.data['message'] ?? 'Gagal mereset password',
          'connected': true,
        };
      }

      return {
        'success': false,
        'message': 'Tidak ada koneksi',
        'connected': false,
      };
    }
  }
}