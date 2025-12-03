import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/waste_bank_submission.dart';

class WasteBankSubmissionService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> storeWasteBankSubmission(Map<String, dynamic> submission) async {
    try {
      final formData = FormData.fromMap({
        "community_id": submission["community_id"],
        "waste_bank_name": submission["waste_bank_name"],
        "waste_bank_location": submission["waste_bank_location"],
        "latitude": submission["latitude"],
        "longitude": submission["longitude"],
        "notes": submission["notes"],
        "status": submission["status"],

        "photo": await MultipartFile.fromFile(
          submission["photo"],
          filename: submission["photo"].split('/').last,
        ),

        "file_document": await MultipartFile.fromFile(
          submission["file_document"],
          filename: submission["file_document"].split('/').last,
        ),
      });

      final response = await _dio.post(
        "/waste-bank-submission/store",
        data: formData,
      );

      if (response.data["success"] == true &&
          response.statusCode == 201) {
        final newSubmission = WasteBankSubmission.fromJson(response.data["data"]);

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": newSubmission,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal membuat pengajuan",
        "connected": true,
      };

    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal membuat pengajuan",
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

