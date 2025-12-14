import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';

class TrashSubmissionsService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> submitTrashSubmissions(int wasteBankId) async {
    try {
      final response = await _dio.post("/trash-submissions/$wasteBankId");

      final success = response.data["success"] == true;

      if (response.statusCode == 201 && success) {
        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ??
            "Gagal mengajukan pengantaran sampah",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ??
              "Gagal mengajukan pengantaran sampah",
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