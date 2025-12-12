import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/waste_bank_submission.dart';

class WasteBankListService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> fetchWasteBankList() async {
    try {
      final response = await _dio.get("/waste-banks");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final List data = response.data["data"] ?? [];
        final wasteBankList =
            data.map((json) => WasteBankSubmission.fromJson(json)).toList();

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": wasteBankList,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat data bank sampah",
        "connected": true,
        "data": <WasteBankSubmission>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ??
              "Gagal memuat data bank sampah",
          "connected": true,
          "data": <WasteBankSubmission>[],
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": <WasteBankSubmission>[],
      };
    }
  }
}
