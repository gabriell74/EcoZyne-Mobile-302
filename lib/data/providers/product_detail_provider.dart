import 'package:ecozyne_mobile/data/models/product.dart';
import 'package:ecozyne_mobile/data/services/marketplace_service.dart';
import 'package:flutter/material.dart';

class ProductDetailProvider with ChangeNotifier {
  final MarketplaceService _marketplaceService = MarketplaceService();

  Product? _product;
  bool _isLoading = false;
  String _message = "";

  int? _currentProductId;
  DateTime? _lastFetchedAt;

  final Duration _cacheDuration = const Duration(seconds: 30);

  Product? get product => _product;
  bool get isLoading => _isLoading;
  String get message => _message;

  Future<void> fetchProductDetail(int productId,
      {bool forceRefresh = false}) async {
    final now = DateTime.now();

    final bool isSameProduct = _currentProductId == productId;
    final bool cacheStillValid = _lastFetchedAt != null &&
        now.difference(_lastFetchedAt!) < _cacheDuration;

    if (!forceRefresh && isSameProduct && cacheStillValid && _product != null) {
      return;
    }

    if (!isSameProduct) {
      _currentProductId = productId;
      _product = null;
      _lastFetchedAt = null;
      notifyListeners();
    }

    _isLoading = true;
    notifyListeners();

    final result = await _marketplaceService.fetchProductDetail(productId);

    if (result["success"] == true && result["data"] != null) {
      _product = result["data"];
      _message = result["message"] ?? "";
      _lastFetchedAt = DateTime.now();
    } else {
      _message = result["message"] ?? "Gagal memuat detail produk";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> placeOrder({
    required int productId,
    required String customerName,
    required String phoneNumber,
    required String orderAddress,
    required int amount,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _marketplaceService.placeOrder(
      productId: productId,
      customerName: customerName,
      phoneNumber: phoneNumber,
      orderAddress: orderAddress,
      amount: amount,
    );

    bool success = false;

    if (result["success"] == true) {
      _message = result["message"] ?? "";
      success = true;

      _lastFetchedAt = null;
    } else {
      _message = result["message"] ?? "Gagal melakukan pemesanan";
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  void clear() {
    _product = null;
    _currentProductId = null;
    _lastFetchedAt = null;
    _isLoading = false;
    _message = "";
  }
}
