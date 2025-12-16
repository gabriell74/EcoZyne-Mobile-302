import 'package:ecozyne_mobile/data/models/waste_bank_order.dart';
import 'package:ecozyne_mobile/data/services/waste_bank_order_service.dart';
import 'package:flutter/material.dart';

class WasteBankOrderProvider with ChangeNotifier {
  final WasteBankOrderService _wasteBankOrderService = WasteBankOrderService();

  List<WasteBankOrder> _orders = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  List<WasteBankOrder> get order => _orders;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

  List<WasteBankOrder> get currentOrders =>
      _orders.where((e) => e.statusOrder == 'pending').toList();

  List<WasteBankOrder> get acceptedOrders =>
      _orders.where((e) => e.statusOrder == 'processed' || e.statusOrder == 'delivered').toList();

  List<WasteBankOrder> get rejectedOrders =>
      _orders.where((e) =>
      e.statusOrder == 'cancelled').toList();

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
}