import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/waste_bank_order.dart';

class WasteBankOrderService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getWasteBankOrders() async {
    try {
      final response = await _dio.get("/waste-bank/orders");

      final isSuccess = response.statusCode == 200 &&
          response.data["success"] == true;

      if (isSuccess) {
        final List list = response.data["data"] ?? [];
        final orders = list
            .map((json) => WasteBankOrder.fromJson(json))
            .toList();

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": orders,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat pesanan",
        "connected": true,
        "data": <WasteBankOrder>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat pesanan",
          "connected": true,
          "data": <WasteBankOrder>[],
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": <WasteBankOrder>[],
      };
    }
  }
}