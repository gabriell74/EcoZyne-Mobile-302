import 'package:ecozyne_mobile/data/models/product.dart';
import 'package:ecozyne_mobile/data/services/waste_bank_product_service.dart';
import 'package:flutter/material.dart';

class WasteBankProductProvider with ChangeNotifier {
  final WasteBankProductService _wasteBankProductService = WasteBankProductService();

  List<Product> _products = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;

  Future<void> getProduct() async {
    _isLoading = true;
    notifyListeners();

    final result = await _wasteBankProductService.fetchProducts();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _products = data;
        _message = result["message"];
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

  Future<bool> addProduct(Map<String, dynamic> submissionData) async {
    _isLoading = true;
    notifyListeners();

    final result = await _wasteBankProductService.storeProduct(submissionData);

    bool success = false;

    if (result["success"] == true && result["data"] != null) {

      final newProduct = result["data"] as Product;

      _products.insert(0, newProduct);
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

  Future<bool> updateProduct(int id, Map<String, dynamic> updateData) async {
    _isLoading = true;
    notifyListeners();

    final result = await _wasteBankProductService.updateProduct(id, updateData);

    bool success = false;

    if (result["success"] == true && result["data"] != null) {
      final updatedProduct = result["data"] as Product;

      final index = _products.indexWhere((p) => p.id == id);

      if (index != -1) {
        _products[index] = updatedProduct;
      }

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


  Future<bool> deleteProduct(int productId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _wasteBankProductService.deleteProduct(productId);

    _connected = result["connected"] ?? false;

    bool success = false;

    if (result["success"] == true) {
      _products.removeWhere((q) => q.id == productId);
      _message = result["message"] ?? "Produk berhasil dihapus";
      success = true;
    } else {
      _message = result["message"] ?? "Gagal menghapus produk";
    }

    _isLoading = false;
    notifyListeners();

    return success;
  }

}