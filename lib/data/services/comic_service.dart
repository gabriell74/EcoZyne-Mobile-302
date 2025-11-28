import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/comic.dart';

class ComicService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> fetchComics() async {
    try {
      final response = await _dio.get("/comics");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final List data = response.data["data"] ?? [];
        final questions = data.map((json) => Comic.fromJson(json)).toList();

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": questions,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat komik",
        "connected": true,
        "data": <Comic>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat komik",
          "connected": true,
          "data": <Comic>[],
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": <Comic>[],
      };
    }
  }

  Future<Map<String, dynamic>> fetchComicDetail(int comicId) async {
    try {
      final response = await _dio.get("/comics/$comicId");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final Map<String, dynamic> data = response.data["data"] ?? {};

        final detail = ComicDetail.fromJson(data);

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": detail,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat detail komik",
        "connected": true,
        "data": null,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat detail komik",
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