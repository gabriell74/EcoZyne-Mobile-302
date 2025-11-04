import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:ecozyne_mobile/data/models/user.dart';
import 'package:ecozyne_mobile/data/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _success = false;
  String? _message;
  User? _user;

  bool get isLoading => _isLoading;
  bool get success => _success;
  String? get message => _message;
  User? get user => _user;

  void clearErrorMessage() {
    _message = null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _success = false;
    _message = null;
    _user = null;
    notifyListeners();

    final result = await _authService.login(email, password);

    if (result["success"] == true && result["user"] != null) {
      _user = result["user"];
      _success = true;
      _message = result["message"] ?? "Login berhasil";
    } else {
      _success = false;
      _message = result["message"] ?? "Login gagal";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register({
    required String username,
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
    required String postalCode,
    required int kecamatanId,
    required int kelurahanId,
  }) async {
    _isLoading = true;
    _success = false;
    _message = null;
    notifyListeners();

    final result = await _authService.register(
      username: username,
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      address: address,
      postalCode: postalCode,
      kecamatanId: kecamatanId,
      kelurahanId: kelurahanId,
    );

    if (result['success'] == true) {
      Validators.clearServerErrors();
      _success = true;
      _message = result['message'] ?? "Registrasi berhasil";
    } else {
      _success = false;
      if (result['errors'] != null) {
        Validators.setServerErrors(result['errors']);
        _message = "Validasi gagal, periksa kembali input kamu.";
      } else {
        Validators.clearServerErrors();
        _message = result['message'] ?? "Registrasi gagal";
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    _success = false;
    _message = null;
    notifyListeners();

    await _authService.logout();
  }
}
