import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/user.dart';

class UserService {
  final _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getUserFromToken(String token) async {
    try {
      final response = await _dio.get(
        '/profile',
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        final user = User.fromJson(response.data["user"]);
        return {
          "success": true,
          "user": user,
          "type": "success",
        };
      }

      return {
        "success": false,
        "type": "server_error",
        "message": response.data["message"] ?? "Gagal mengambil profil",
      };
    }

    on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        return {
          "success": false,
          "type": "no_connection",
          "message": "Tidak ada koneksi internet",
        };
      }

      if (e.response?.statusCode == 401) {
        return {
          "success": false,
          "type": "token_invalid",
          "message": "Token tidak valid atau sudah kedaluwarsa",
        };
      }

      return {
        "success": false,
        "type": "server_error",
        "message": "Terjadi kesalahan tak terduga",
      };
    }
  }


  Future<Map<String, dynamic>> updateProfile(User user, {
    required String username,
    required String name,
    required String phoneNumber,
    required String email,
    required String address,
    required int kelurahanId,
    required String postalCode,
  }) async {
    try {
      final data = user.toJson(
        username: username,
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        address: address,
        kelurahanId: kelurahanId,
        postalCode: postalCode,
      );

      final response = await _dio.put('/update-profile', data: data);

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        return {
          "success": true,
          "message": response.data["message"],
          "data": response.data["data"],
          "connected": true,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memperbarui profil",
        "connected": true,
      };

    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memperbarui profil",
          "connected": true,
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
      };
    }
  }
}
