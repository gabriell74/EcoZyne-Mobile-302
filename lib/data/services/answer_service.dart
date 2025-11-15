import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/answer.dart';

class AnswerService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getAllAnswers(int questionId) async {
    try {
      final response = await _dio.get("/answers/$questionId");
      final success = response.data["success"] == true;

      if (success && response.statusCode == 200) {
        final List data = response.data["data"] ?? [];
        final answers = data.map((json) => Answer.fromJson(json)).toList();

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": answers,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat jawaban",
        "connected": true,
        "data": <Answer>[],
      };
    } on DioException catch (e) {
      return {
        "success": false,
        "message": e.response?.data["message"] ?? "Tidak ada koneksi",
        "connected": e.response != null,
        "data": <Answer>[],
      };
    }
  }

  Future<Map<String, dynamic>> storeAnswer(int questionId, String answerText) async {
    try {
      final response = await _dio.post("/answer/store/$questionId", data: {
        "answer": answerText,
      });

      final success = response.data["success"] == true;

      if (success) {
        final answer = Answer.fromJson(response.data["data"]);
        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": answer,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal menambah jawaban",
        "connected": true,
        "data": null,
      };
    } on DioException catch (e) {
      return {
        "success": false,
        "message": e.response?.data["message"] ?? "Tidak ada koneksi",
        "connected": e.response != null,
        "data": null,
      };
    }
  }

  Future<Map<String, dynamic>> updateAnswer(int answerId, String answerText) async {
    try {
      final response = await _dio.put("/answer/update/$answerId", data: {
        "answer": answerText,
      });

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final answer = Answer.fromJson(response.data["data"]);
        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": answer,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memperbarui jawaban",
        "connected": true,
        "data": null,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memperbarui jawaban",
          "connected": true,
          "data": null,
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": null,
      };
    }
  }

  Future<Map<String, dynamic>> deleteAnswer(int answerId) async {
    try {
      final response = await _dio.delete("/answer/delete/$answerId");

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
        "message": response.data["message"] ?? "Gagal menghapus jawaban",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal menghapus jawaban",
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
