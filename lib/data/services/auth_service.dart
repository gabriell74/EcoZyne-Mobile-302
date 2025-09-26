import 'dart:convert';

import 'package:dio/dio.dart';

class AuthService {
  final dio = Dio(

    BaseOptions(
      baseUrl: "http://10.66.6.207:8000/api",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<Map<String, dynamic>> login(String email, String password) async {
    try{
      final response = await dio.post(
        '/login',
        data: {
          "email": email,
          "password": password,
        },
        options: Options(
          headers: {"Accept": "application/json"},
        ),
      );

      return {
        "success": true,
        "data": response.data,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Login gagal",
        };
      } else {
        return {
          "success": false,
          "message": "Tidak ada koneksi ke server",
        };
      }
    }
  }
}