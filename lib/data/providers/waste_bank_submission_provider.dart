import 'package:ecozyne_mobile/data/models/waste_bank_submission.dart';
import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/data/services/waste_bank_submission_service.dart';

class WasteBankSubmissionProvider with ChangeNotifier {
  final WasteBankSubmissionService _submissionService = WasteBankSubmissionService();

  List<WasteBankSubmission> _submissions = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  List<WasteBankSubmission> get submissions => _submissions;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

  Future<bool> addSubmission(Map<String, dynamic> submissionData) async {
    _isLoading = true;
    notifyListeners();

    final result = await _submissionService.storeWasteBankSubmission(submissionData);

    bool success = false;

    if (result["success"] == true && result["data"] != null) {

      final newSubmission = result["data"] as WasteBankSubmission;

      _submissions.insert(0, newSubmission);
      _message = result["message"];
      success = true;

    } else {
      _message = result["message"];
    }

    _connected = result["connected"];
    _isLoading = false;

    notifyListeners();
    return success;
  }

  Future<void> getSubmissionHistory() async {
    _isLoading = true;
    notifyListeners();

    final result = await _submissionService.getSubmissionHistory();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _submissions = data;
        _message = result["message"];
      } else {
        _submissions = [];
        _message = "Tidak ada riwayat pengajuan, Ayo mendaftar!";
      }
    } else {
      _submissions = [];
      _message = result["message"] ?? "Gagal memuat riwayat pengajuan";
    }

    _isLoading = false;
    notifyListeners();
  }
}

