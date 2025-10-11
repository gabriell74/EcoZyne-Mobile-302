import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/article.dart';

class ArticleService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getArticles() async {
    try {
      final response = await _dio.get("/articles");

      if (response.statusCode == 200) {
        final List data = response.data["data"];
        final articles = data.map((json) => Article.fromJson(json)).toList();

        return {
          "success": true,
          "message": "Berhasil mengambil artikel",
          "data": articles,
        };
      } else {
        return {
          "success": false,
          "message": "Gagal load artikel",
          "data": <Article>[],
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal load artikel",
          "data": <Article>[],
        };
      } else {
        return {
          "success": false,
          "message": "Tidak ada koneksi ke server",
          "data": <Article>[],
        };
      }
    }
  }

  Future<Map<String, dynamic>> getLatestArticles() async {
    try {
      final response = await _dio.get("/articles/latest");

      if (response.statusCode == 200) {
        final List data = response.data["data"];
        final articles = data.map((json) => Article.fromJson(json)).toList();

        return {
          "success": true,
          "message": "Berhasil mengambil artikel",
          "data": articles,
        };
      } else {
        return {
          "success": false,
          "message": "Gagal load artikel",
          "data": <Article>[],
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal load artikel",
          "data": <Article>[],
        };
      } else {
        return {
          "success": false,
          "message": "Tidak ada koneksi ke server",
          "data": <Article>[],
        };
      }
    }
  }
}
