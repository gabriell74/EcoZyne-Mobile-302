import 'package:ecozyne_mobile/data/models/trash_transaction.dart';
import 'package:ecozyne_mobile/data/services/trash_transaction_service.dart';
import 'package:flutter/material.dart';

class TrashTransactionProvider with ChangeNotifier {
  final TrashTransactionService _trashTransactionService = TrashTransactionService();

  List<TrashTransaction> _trashTransactions = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  bool _isLoadingAccepted = false;
  String _messageAccepted = "";
  bool _isLoadingRejected = false;
  String _messageRejected = "";
  bool _isLoadingCompleted = false;
  String _messageCompleted = "";

  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;
  bool get isLoadingAccepted => _isLoadingAccepted;
  String get messageAccepted => _messageAccepted;
  bool get isLoadingRejected => _isLoadingRejected;
  String get messageRejected => _messageRejected;
  bool get isLoadingCompleted => _isLoadingCompleted;
  String get messageCompleted => _messageCompleted;

  List<TrashTransaction> get currentSubmissions =>
      _trashTransactions.where((e) => e.status == 'pending').toList();

  List<TrashTransaction> get acceptedSubmissions =>
      _trashTransactions.where((e) => e.status == 'approved').toList();

  List<TrashTransaction> get rejectedSubmissions =>
      _trashTransactions.where((e) => e.status == 'rejected').toList();

  Future<bool> submitTrashSubmissions(int wasteBankId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _trashTransactionService.submitTrashSubmissions(wasteBankId);

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

  Future<void> getTrashTransactions() async {
    _isLoading = true;
    notifyListeners();

    final result = await _trashTransactionService.getTrashTransactions();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _trashTransactions = data;
        _message = result["message"];
      } else if (currentSubmissions.isEmpty){
        _message = "Belum ada pengantaran sampah";
      } else {
        _trashTransactions = [];
        _message = "Belum ada pengantaran sampah";
      }
    } else {
      _trashTransactions = [];
      _message = result["message"] ?? "Gagal memuat pengantaran sampah";
    }

    if (_trashTransactions.isNotEmpty && currentSubmissions.isEmpty) {
      _message = "Belum ada pengantaran sampah";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> acceptSubmissions(int orderId) async {
    _isLoadingAccepted = true;
    notifyListeners();

    final index = _trashTransactions.indexWhere((o) => o.id == orderId);
    if (index == -1) {
      _isLoadingAccepted = false;
      notifyListeners();
      return false;
    }

    final result = await _trashTransactionService.acceptSubmissions(orderId);

    if (result["success"] == true) {
      _trashTransactions[index] = result["data"];
      _messageAccepted = result["message"];
      _isLoadingAccepted = false;
      notifyListeners();
      return true;
    }

    _messageAccepted = result["message"] ?? "Gagal menerima pengantaran sampah";
    _isLoadingAccepted = false;
    notifyListeners();
    return false;
  }

  Future<bool> rejectSubmissions(int orderId, String rejectionReason) async {
    _isLoadingRejected = true;
    notifyListeners();

    final index = _trashTransactions.indexWhere((o) => o.id == orderId);
    if (index == -1) {
      _isLoadingRejected = false;
      notifyListeners();
      return false;
    }

    final result = await _trashTransactionService.rejectSubmissions(orderId, rejectionReason);

    if (result["success"] == true) {
      _trashTransactions[index] = result["data"];
      _messageRejected = result["message"];
      _isLoadingRejected = false;
      notifyListeners();
      return true;
    }

    _messageRejected = result["message"] ?? "Gagal menolak pengantaran sampah";
    _isLoadingRejected = false;
    notifyListeners();
    return false;
  }
}