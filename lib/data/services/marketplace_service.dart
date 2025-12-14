import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/order.dart';
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

  Future<Map<String, dynamic>> fetchProductDetail(int productId) async {
    try {
      final response = await _dio.get("/marketplace/products/$productId");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final product = Product.fromJson(response.data["data"]);

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": product,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat detail produk",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat detail produk",
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

  Future<Map<String, dynamic>> placeOrder({
   required int productId,
   required String customerName,
   required String phoneNumber,
   required  String orderAddress,
    required int amount
  }) async {
    try {
      final response = await _dio.post(
        "/orders/community/$productId/place",
        data: {
          "order_customer": customerName,
          "order_phone_number": phoneNumber,
          "order_address": orderAddress,
          "amount": amount,
        },
      );

      final success = response.data["success"] == true;

      if ((response.statusCode == 201 || response.statusCode == 200) && success) {
        final newOrder = Order.fromJson(response.data["data"]["order"]);

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": newOrder,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal membuat pesanan",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal membuat pesanan",
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