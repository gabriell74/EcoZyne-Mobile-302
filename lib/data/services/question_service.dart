import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/question.dart';

class QuestionService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String,dynamic>> fetchQuestions() async {
    try {
      final response = await _dio.get("/questions");

      if (response.statusCode == 200) {
        final List data = response.data["data"] ?? [];
        final questions = data.map((json) => Question.fromJson(json)).toList();

        return {
          "success": response.data["success"],
          "message": response.data["message"],
          "connected": true,
          "data": questions,
        };
      } else {
        return {
          "success": false,
          "message": "Gagal memuat pertanyaan",
          "connected": true,
          "data": <Question>[],
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat pertanyaan",
          "connected": true,
          "data": <Question>[],
        };
      } else {
        return {
          "success": false,
          "message": "Tidak ada koneksi",
          "connected": false,
          "data": <Question>[],
        };
      }
    }
  }

  Future<Map<String, dynamic>> toggleLike(int questionId) async {
    try {
      final response = await _dio.post("/question/$questionId/like");

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "total_like": response.data["total_like"],
          "is_liked": response.data["is_liked"],
        };
      } else {
        return {
          "success": false,
          "message": "Gagal memperbarui like",
          "connected": true,
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memperbarui like",
          "connected": true,
        };
      } else {
        return {
          "success": false,
          "message": "Tidak ada koneksi",
          "connected": false,
        };
      }
    }
  }
}