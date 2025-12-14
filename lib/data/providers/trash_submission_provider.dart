import 'package:ecozyne_mobile/data/services/trash_submissions_service.dart';
import 'package:flutter/material.dart';

class TrashSubmissionsProvider with ChangeNotifier {
  final TrashSubmissionsService _trashSubmissionsService = TrashSubmissionsService();

  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

  Future<bool> submitTrashSubmissions(int wasteBankId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _trashSubmissionsService.submitTrashSubmissions(wasteBankId);

    bool success = false;

    if (result["success"] == true) {
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