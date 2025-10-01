import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/article.dart';

class ArticleService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getArticles() async {
    try {
      final response = await _dio.get("/articles");

      final List data = response.data["data"];
      final articles = data.map((json) => Article.fromJson(json)).toList();

      return {
        "success": response.data["success"],
        "message": response.data["message"],
        "data": articles,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": e.response?.data["success"] ?? false,
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