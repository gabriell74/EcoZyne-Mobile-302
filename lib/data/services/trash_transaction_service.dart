import 'package:dio/dio.dart';
import 'package:ecozyne_mobile/data/api_client.dart';
import 'package:ecozyne_mobile/data/models/trash_transaction.dart';

class TrashTransactionService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> submitTrashSubmissions(int wasteBankId) async {
    try {
      final response = await _dio.post("/trash-transactions/waste-bank/$wasteBankId");

      final success = response.data["success"] == true;

      if (response.statusCode == 201 && success) {
        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ??
            "Gagal mengajukan pengantaran sampah",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ??
              "Gagal mengajukan pengantaran sampah",
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

  Future<Map<String, dynamic>> getTrashTransactions() async {
    try {
      final response = await _dio.get("/trash-transactions/waste-bank");

      final isSuccess = response.statusCode == 200 &&
          response.data["success"] == true;

      if (isSuccess) {
        final List list = response.data["data"] ?? [];
        final trashTransaction = list
            .map((json) => TrashTransaction.fromJson(json))
            .toList();

        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": trashTransaction,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal memuat pengajuan pengantaran",
        "connected": true,
        "data": <TrashTransaction>[],
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal memuat pengajuan pengantaran",
          "connected": true,
          "data": <TrashTransaction>[],
        };
      }

      return {
        "success": false,
        "message": "Tidak ada koneksi",
        "connected": false,
        "data": <TrashTransaction>[],
      };
    }
  }

  Future<Map<String, dynamic>> acceptSubmissions(int orderId) async {
    try {
      final response = await _dio.put("/trash-transactions/$orderId/approve");

      final isSuccess = response.statusCode == 200 &&
          response.data["success"] == true;

      final updatedSubmission = TrashTransaction.fromJson(response.data["data"]);

      if (isSuccess) {
        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": updatedSubmission,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal menerima pengantaran sampah",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal menerima pengantaran sampah",
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

  Future<Map<String, dynamic>> rejectSubmissions(int orderId, String rejectionReason) async {
    try {
      final response = await _dio.put(
        "/trash-transactions/$orderId/reject",
        data: {"rejection_reason": rejectionReason}
      );

      final isSuccess = response.statusCode == 200 &&
          response.data["success"] == true;

      final updatedSubmission = TrashTransaction.fromJson(response.data["data"]);

      if (isSuccess) {
        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": updatedSubmission,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal menolak pengantaran sampah",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal menolak pengantaran sampah",
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

  Future<Map<String, dynamic>> storeTrash(int transactionId,Map<String, dynamic> wasteDeposit) async {
    try {

      final formData = FormData.fromMap({
        "_method": "PUT",
        "trash_weight": wasteDeposit["trash_weight"],
        "trash_image": await MultipartFile.fromFile(
          wasteDeposit["trash_image"],
          filename: wasteDeposit["trash_image"].split('/').last,
        ),
      });

      final response = await _dio.post(
        "/trash-transactions/$transactionId/complete",
        data: formData
      );

      final isSuccess = response.statusCode == 200 &&
          response.data["success"] == true;

      final updatedSubmission = TrashTransaction.fromJson(response.data["data"]);

      if (isSuccess) {
        return {
          "success": true,
          "message": response.data["message"],
          "connected": true,
          "data": updatedSubmission,
        };
      }

      return {
        "success": false,
        "message": response.data["message"] ?? "Gagal menyetor sampah",
        "connected": true,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Gagal menyetor sampah",
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