import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/exchange_history.dart';

class HistoryService {
  final _dio = ApiClient.dio;

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
}