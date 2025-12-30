import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/exchange_history.dart';
import 'package:ecozyne_mobile/data/models/order.dart';
import 'package:ecozyne_mobile/data/models/point_income_history.dart';
import 'package:ecozyne_mobile/data/models/trash_submissions.dart';

class HistoryService {
  final _dio = ApiClient.dio;

  Future<Map<String, dynamic>> fetchPointIncomeHistory() async {
    try {
      final response = await _dio.get("/point/income/history");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final data = response.data["data"];
        final pointIncome = PointIncomeHistory.fromJson(data);

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": pointIncome,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat riwayat pemasukan poin",
        "connected": true,
        "data": null,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat riwayat pemasukan poin",
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

  Future<Map<String, dynamic>> fetchRewardExchangeHistory() async {
    try {
      final response = await _dio.get("/reward/exchange/history");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final List data = response.data["data"] ?? [];
        final exchangeHistory = data
            .map((item) => ExchangeHistory.fromJson(item as Map<String, dynamic>))
            .toList();

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": exchangeHistory,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat riwayat penukaran hadiah",
        "connected": true,
        "data": <ExchangeHistory>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat riwayat penukaran hadiah",
          "connected": true,
          "data": <ExchangeHistory>[],
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": <ExchangeHistory>[],
      };
    }
  }

  Future<Map<String, dynamic>> fetchProductOrderHistory() async {
    try {
      final response = await _dio.get("/product/order/history");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final List data = response.data["data"] ?? [];
        final orderHistory = data
            .map((item) => Order.fromJson(item as Map<String, dynamic>))
            .toList();

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": orderHistory,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat riwayat pemesanan produk",
        "connected": true,
        "data": <Order>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat riwayat pemesanan produk",
          "connected": true,
          "data": <Order>[],
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": <Order>[],
      };
    }
  }

  Future<Map<String, dynamic>> fetchTrashSubmissionsHistory() async {
    try {
      final response = await _dio.get("/trash-transactions/submissions");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final List data = response.data["data"] ?? [];
        final trashSubmissions = data
            .map((item) => TrashSubmissions.fromJson(item as Map<String, dynamic>))
            .toList();

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": trashSubmissions,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat pengajuan setoran sampah",
        "connected": true,
        "data": <TrashSubmissions>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat pengajuan setoran sampah",
          "connected": true,
          "data": <TrashSubmissions>[],
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": <Order>[],
      };
    }
  }
}