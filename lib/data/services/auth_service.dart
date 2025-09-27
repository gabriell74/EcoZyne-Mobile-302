import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/user.dart';

class AuthService {
  final dio = ApiClient.dio;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {"email": email, "password": password},
      );

      final User user = User.fromJson(response.data["user"]);

      return {
        "success": response.data["success"],
        "message": response.data["message"],
        "user": user,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": e.response?.data["success"],
          "message": e.response?.data["message"] ?? "Login gagal",
        };
      } else {
        return {"success": false, "message": "Tidak ada koneksi ke server"};
      }
    }
  }
}
