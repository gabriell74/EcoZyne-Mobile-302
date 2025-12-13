import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/product.dart';

class MarketplaceService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> fetchProducts() async {
    try {
      final response = await _dio.get("/marketplace/products");

      final success = response.data["success"] = true;

      if (response.statusCode == 200 && success) {
        final List data = response.data["data"] ?? [];
        final questions = data.map((json) => Product.fromJson(json)).toList();

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": questions,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat produk",
        "connected": true,
        "data": <Product>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat produk",
          "connected": true,
          "data": <Product>[],
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": <Product>[],
      };
    }
  }
}