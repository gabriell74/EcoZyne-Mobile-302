import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/question.dart';

class QuestionService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> fetchQuestions() async {
    try {
      final response = await _dio.get("/questions");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final List data = response.data["data"] ?? [];
        final questions = data.map((json) => Question.fromJson(json)).toList();

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": questions,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat pertanyaan",
        "connected": true,
        "data": <Question>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat pertanyaan",
          "connected": true,
          "data": <Question>[],
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": <Question>[],
      };
    }
  }

  Future<Map<String, dynamic>> storeQuestion(String question) async {
    try {
      final response = await _dio.post(
        "/question/store",
        data: {"question": question},
      );

      final success = response.data["success"] == true;

      if ((response.statusCode == 201 || response.statusCode == 200) && success) {
        final newQuestion = Question.fromJson(response.data["data"]);

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": newQuestion,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal membuat pertanyaan",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal membuat pertanyaan",
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

  Future<Map<String, dynamic>> updateQuestion(int questionId, String question) async {
    try {
      final response = await ApiClient.dio.put(
        "/question/update/$questionId",
        data: {"question": question},
      );

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
        "message": response.data["message"] ?? "Gagal memperbarui pertanyaan",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memperbarui pertanyaan",
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

  Future<Map<String, dynamic>> toggleLike(int questionId) async {
    try {
      final response = await _dio.patch("/question/$questionId/like");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "total_like": response.data["total_like"],
          "is_liked": response.data["is_liked"],
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memperbarui like",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memperbarui like",
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

  Future<Map<String, dynamic>> deleteQuestion(int questionId) async {
    try {
      final response = await _dio.delete("/question/delete/$questionId");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal menghapus pertanyaan",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal menghapus pertanyaan",
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