import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/eco_enzyme_tracking.dart';

class EcoEnzymeTrackingService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> fetchEcoEnzymeTracking() async {
    try {
      final response = await _dio.get("/eco-enzyme-tracking/get-all-batches");

      final success = response.data["success"] == true;

      if (response.statusCode == 200 && success) {
        final List data = response.data["data"] ?? [];
        final batchTracking = data.map((json) => EcoEnzymeTracking.fromJson(json)).toList();

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": batchTracking,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat pertanyaan",
        "connected": true,
        "data": <EcoEnzymeTracking>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat pertanyaan",
          "connected": true,
          "data": <EcoEnzymeTracking>[],
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": <EcoEnzymeTracking>[],
      };
    }
  }

  Future<Map<String, dynamic>> storeBatchTracking(EcoEnzymeTracking batch) async {
    try{
      final response = await _dio.post(
        "/eco-enzyme-tracking/store-batch",
        data: batch.toJson()
      );

      final success = response.data["success"] == true;

      if(response.statusCode == 201 && success) {
        final newBatch = EcoEnzymeTracking.fromJson(response.data["data"]);

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": newBatch
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal membuat batch Eco Enzyme",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal membuat batch Eco Enzyme",
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