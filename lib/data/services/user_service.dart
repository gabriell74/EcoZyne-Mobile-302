import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/user.dart';

class UserService {
  final _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getUserFromToken(String token) async {
    try {
      final response = await _dio.get(
        '/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        final user = User.fromJson(response.data["user"]);
        return {
          "success": true,
          "user": user,
        };
      } else {
        return {
          "success": false,
          "message": response.data["message"] ?? "Gagal mengambil profil",
        };
      }
    } on DioException catch (e) {
      final res = e.response;
      return {
        "success": false,
        "message": res?.data["message"] ?? "Token tidak valid atau kedaluwarsa",
      };
    } catch (_) {
      return {
        "success": false,
        "message": "Terjadi kesalahan tak terduga",
      };
    }
  }
}