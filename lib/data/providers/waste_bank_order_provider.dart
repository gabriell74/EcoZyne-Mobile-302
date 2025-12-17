import 'package:ecozyne_mobile/data/models/waste_bank_order.dart';
import 'package:ecozyne_mobile/data/services/waste_bank_order_service.dart';
import 'package:flutter/material.dart';

class WasteBankOrderProvider with ChangeNotifier {
  final WasteBankOrderService _wasteBankOrderService = WasteBankOrderService();

  List<WasteBankOrder> _orders = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  bool _isLoadingAccepted = false;
  String _messageAccepted = "";
  bool _isLoadingRejected = false;
  String _messageRejected = "";

  List<WasteBankOrder> get order => _orders;
  bool get isLoading => _isLoading;
  bool get isLoadingAccepted => _isLoadingAccepted;
  String get message => _message;
  String get messageAccepted => _messageAccepted;
  bool get connected => _connected;
  bool get isLoadingRejected => _isLoadingRejected;
  String get messageRejected => _messageRejected;

  List<WasteBankOrder> get currentOrders =>
      _orders.where((e) => e.statusOrder == 'pending').toList();

  List<WasteBankOrder> get acceptedOrders => _orders
      .where(
        (e) => e.statusOrder == 'processed' || e.statusOrder == 'delivered',
      )
      .toList();

  List<WasteBankOrder> get rejectedOrders =>
      _orders.where((e) => e.statusOrder == 'cancelled' || e.statusOrder == 'rejected').toList();

  Future<void> getWasteBankOrders() async {
    _isLoading = true;
    notifyListeners();

    final result = await _wasteBankOrderService.getWasteBankOrders();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _orders = data;
        _message = result["message"];
      } else {
        _orders = [];
        _message = "Belum ada pesanan produk";
      }
    } else {
      _orders = [];
      _message = result["message"] ?? "Gagal memuat pesanan produk";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> acceptOrder(int orderId) async {
    _isLoadingAccepted = true;
    notifyListeners();

    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index == -1) {
      _isLoadingAccepted = false;
      notifyListeners();
      return false;
    }

    final result = await _wasteBankOrderService.acceptOrder(orderId);

    if (result["success"] == true) {
      _orders[index] = result["data"];
      _messageAccepted = result["message"];
      _isLoadingAccepted = false;
      notifyListeners();
      return true;
    }

    _messageAccepted = result["message"] ?? "Gagal menerima pesanan";
    _isLoadingAccepted = false;
    notifyListeners();
    return false;
  }

  
  Future<bool> rejectOrder(int orderId, String cancellationReason) async {
    _isLoadingRejected = true;
    notifyListeners();

    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index == -1) {
      _isLoadingRejected = false;
      notifyListeners();
      return false;
    }

    final result = await _wasteBankOrderService.rejectOrder(orderId, cancellationReason);

    if (result["success"] == true) {
      _orders[index] = result["data"];
      _messageRejected = result["message"];
      _isLoadingRejected = false;
      notifyListeners();
      return true;
    }

    _messageRejected = result["message"] ?? "Gagal menolak pesanan";
    _isLoadingRejected = false;
    notifyListeners();
    return false;
  }
}
