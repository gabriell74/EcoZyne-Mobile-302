import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/models/activity.dart';
import 'package:ecozyne_mobile/data/api_client.dart';

class ActivityService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> fetchActivities() async {
    try {
      final response = await _dio.get("/activities");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final List data = response.data["data"] ?? [];
        final activities = data.map((json) => Activity.fromJson(json)).toList();

        return {
          "success": success,
          "message": response.data["message"] ?? "Berhasil mengambil data aktivitas",
          "connected": true,
          "data": activities,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat aktivitas",
        "connected": true,
        "data": <Activity>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat aktivitas",
          "connected": true,
          "data": <Activity>[],
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": <Activity>[],
      };
    }
  }

  Future<Map<String, dynamic>> fetchLatestActivity() async {
    try {
      final response = await _dio.get("/activities/latest");

      final success = response.data["success"] == true;

      Activity? activity;
      if (success) {
        final data = response.data["data"];
        if (data != null && data is Map<String, dynamic>) {
          activity = Activity.fromJson(data);
        }
      }

      return {
        "success": success,
        "message": response.data["message"] ?? "Berhasil mengambil aktivitas terbaru",
        "connected": true,
        "data": activity,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat aktivitas terbaru",
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
}
