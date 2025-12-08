import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/product.dart';

class WasteBankProductService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> fetchProducts() async {
    try {
      final response = await _dio.get("/waste-bank/products");

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

  Future<Map<String, dynamic>> storeProduct(Map<String,dynamic> product) async {
    try {
      final formData = FormData.fromMap({
        "product_name": product["product_name"],
        "description": product["description"],
        "price": product["price"],
        "stock": product["stock"],

        "photo": await MultipartFile.fromFile(
          product["photo"],
          filename: product["photo"].split('/').last,
        ),
      });

      final response = await _dio.post(
        "/waste-bank/products/create",
        data: formData,
      );

      final success = response.data["success"] == true;

      if ((response.statusCode == 201) && success) {
        final newProduct = Product.fromJson(response.data["data"]);

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": newProduct,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal manambah produk",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal menambah produk",
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