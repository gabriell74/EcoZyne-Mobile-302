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
          "message": response.data["message"] ?? "Berhasil mengambil data kegiatan",
          "connected": true,
          "data": activities,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat kegiatan",
        "connected": true,
        "data": <Activity>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat kegiatan",
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

  Future<Map<String, dynamic>> activityRegister(int activityId) async {
    try {
      final response = await _dio.post("/activities/$activityId/register");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        return {
          "success": success,
          "message": response.data["message"] ?? "Berhasil mendaftar kegiatan",
          "connected": true,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal mendaftar kegiatan",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message":
              e.response?.data["message"] ?? "Gagal mendaftar kegiatan",
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

  Future<Map<String, dynamic>> fetchCompletedActivity() async {
    try {
      final response = await _dio.get('/activities/completed');

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final List data = response.data["data"] ?? [];
        final activities = data.map((json) => Activity.fromJson(json)).toList();

        return {
          "success": success,
          "message": response.data["message"] ?? "Berhasil mengambil data kegiatan selesai",
          "connected": true,
          "data": activities,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat kegiatan yang sudah selesai",
        "connected": true,
        "data": <Activity>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat kegiatan yang sudah selesai",
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
        "message": response.data["message"] ?? "Berhasil mengambil kegiatan terbaru",
        "connected": true,
        "data": activity,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat kegiatan terbaru",
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
