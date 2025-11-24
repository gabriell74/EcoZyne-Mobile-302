import 'package:ecozyne_mobile/data/models/eco_enzyme_tracking.dart';
import 'package:ecozyne_mobile/data/services/eco_enzyme_tracking_service.dart';
import 'package:flutter/material.dart';

class EcoEnzymeTrackingProvider with ChangeNotifier {
  final EcoEnzymeTrackingService _ecoEnzymeTrackingService = EcoEnzymeTrackingService();

  List<EcoEnzymeTracking> _batchTracking = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  List<EcoEnzymeTracking> get batchTracking => _batchTracking;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

  Future<void> getEcoEnzymeTracking() async {
    _isLoading = true;
    notifyListeners();

    final result = await _ecoEnzymeTrackingService.fetchEcoEnzymeTracking();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _batchTracking = data;
        _message = result["message"];
      } else {
        _batchTracking = [];
        _message = "Belum ada pembuatan Eco Enzyme";
      }
    } else {
      _batchTracking = [];
      _message = result["message"] ?? "Gagal memuat pertanyaan";
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<bool> addBatchTracking(EcoEnzymeTracking batch) async {
    _isLoading = true;
    notifyListeners();

    final result = await _ecoEnzymeTrackingService.storeBatchTracking(batch);

    bool success = false;

    if (result["success"] == true && result["data"] != null) {
      final newBatch = result["data"] as EcoEnzymeTracking;

      _batchTracking.insert(0, newBatch);
      _message = result["message"];
      success = true;
      notifyListeners();
    } else {
      _message = result["message"];
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}