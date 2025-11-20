import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/reward.dart';

class RewardService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> fetchRewards() async {
    try {
      final response = await _dio.get("/rewards");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final List data = response.data["data"] ?? [];
        final activities = data.map((json) => Reward.fromJson(json)).toList();

        return {
          "success": success,
          "message":
              response.data["message"] ?? "Berhasil mengambil data hadiah",
          "connected": true,
          "data": activities,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat hadiah",
        "connected": true,
        "data": <Reward>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat hadiah",
          "connected": true,
          "data": <Reward>[],
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": <Reward>[],
      };
    }
  }
}
