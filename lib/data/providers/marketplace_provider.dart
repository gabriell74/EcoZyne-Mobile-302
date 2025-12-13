import 'package:ecozyne_mobile/data/models/product.dart';
import 'package:ecozyne_mobile/data/services/marketplace_service.dart';
import 'package:flutter/material.dart';

class MarketplaceProvider with ChangeNotifier {
  final MarketplaceService _marketplaceService = MarketplaceService();

  List<Product> _products = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  DateTime? _lastFetchedProducts;
  final Duration _cacheDuration = const Duration(minutes: 5);

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

  Future<void> getProduct({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _products.isNotEmpty &&
        _lastFetchedProducts != null &&
        DateTime.now().difference(_lastFetchedProducts!) < _cacheDuration) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _marketplaceService.fetchProducts();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _products = data;
        _message = result["message"];
        _lastFetchedProducts = DateTime.now();
      } else {
        _products = [];
        _message = "Belum ada produk yang dijual";
      }
    } else {
      _products = [];
      _message = result["message"] ?? "Gagal memuat produk";
    }

    _isLoading = false;
    notifyListeners();
  }
}