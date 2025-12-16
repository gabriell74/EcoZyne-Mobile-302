import 'package:ecozyne_mobile/core/utils/history_helper.dart';
import 'package:ecozyne_mobile/data/models/order.dart';
import 'package:ecozyne_mobile/data/services/history_service.dart';
import 'package:ecozyne_mobile/data/services/marketplace_service.dart';
import 'package:flutter/material.dart';

class OrderHistoryProvider with ChangeNotifier {
  final HistoryService _historyService = HistoryService();
  final MarketplaceService _marketplaceService = MarketplaceService();

  List<Order> _orderHistory = [];
  Map<String, List<Order>> _groupedHistory = {};
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  List<Order> get orderHistory => _orderHistory;
  Map<String, List<Order>> get groupedHistory => _groupedHistory;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

  Future<void> getProductOrderHistory() async {
    _isLoading = true;
    notifyListeners();

    final result = await _historyService.fetchProductOrderHistory();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data.isNotEmpty) {
        _orderHistory = data.cast<Order>();
        _groupedHistory = groupByDate<Order>(
          _orderHistory,
          getDate: (item) => DateTime.parse(item.createdAt),
        );
        _message = result["message"] ?? "";
      } else {
        _orderHistory = [];
        _groupedHistory = {};
        _message = "Belum ada riwayat pemesanan produk";
      }
    } else {
      _orderHistory = [];
      _groupedHistory = {};
      _message = result["message"] ?? "Gagal memuat riwayat pemesanan produk";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> cancelOrder(int orderId, String cancellationReason) async {
    _isLoading = true;
    notifyListeners();

    final index = _orderHistory.indexWhere((order) => order.id == orderId);

    if (index == -1) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final result = await _marketplaceService.cancelOrder(orderId, cancellationReason);

    if(result["success"]) {
      _orderHistory[index].statusOrder = result["data"]["status_order"];
      _orderHistory[index].statusPayment = result["data"]["status_payment"];
      _message = result["message"];
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

}