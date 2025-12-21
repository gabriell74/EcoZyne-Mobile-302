import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:ecozyne_mobile/data/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _success = false;
  String? _message;

  bool _isOtpLoading = false;
  bool get isOtpLoading => _isOtpLoading;
  bool _isOtpRateLimited = false;
  bool get isOtpRateLimited => _isOtpRateLimited;
  bool _isResendOtpLoading = false;
  bool _isResendOtpRateLimited = false;

  bool get isResendOtpLoading => _isResendOtpLoading;
  bool get isResendOtpRateLimited => _isResendOtpRateLimited;



  bool get isLoading => _isLoading;
  bool get success => _success;
  String? get message => _message;

  void clearErrorMessage() {
    _message = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _success = false;
    _message = null;
    notifyListeners();

    final result = await _authService.login(email, password);

    if (result["success"] == true) {
      _success = true;
      _message = result["message"] ?? "Login berhasil";
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _success = false;
      _message = result["message"] ?? "Login gagal";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String role,
    required String name,
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
      email: email,
      password: password,
      role: role,
      name: name,
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
        _message = result["message"] ?? "Validasi gagal, periksa kembali input kamu.";
      } else {
        Validators.clearServerErrors();
        _message = result['message'] ?? "Registrasi gagal";
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    _isOtpLoading = true;
    _success = false;
    _message = null;
    notifyListeners();

    final result = await _authService.verifyOtp(
      email: email,
      otp: otp,
    );

    if (result['success'] == true) {
      _success = true;
      _message = result['message'] ?? 'Verifikasi berhasil';

      _isOtpRateLimited = false;
    } else {
      _success = false;
      _message = result['message'] ?? 'Verifikasi gagal';

      if ((_message ?? '').toLowerCase().contains('terlalu')) {
        _isOtpRateLimited = true;
      }
    }

    _isOtpLoading = false;
    notifyListeners();
  }

  Future<void> resendOtp({
    required String email,
  }) async {
    _isResendOtpLoading = true;
    _message = null;
    notifyListeners();

    final result = await _authService.resendOtp(email: email);

    if (result['success'] == true) {
      _message = result['message'] ?? 'OTP berhasil dikirim ulang';

      _isOtpRateLimited = false;
      _isResendOtpRateLimited = false;
    } else {
      _message = result['message'] ?? 'Gagal mengirim ulang OTP';

      if (result['rate_limited'] == true ||
          (_message ?? '').toLowerCase().contains('terlalu')) {
        _isResendOtpRateLimited = true;
      }
    }

    _isResendOtpLoading = false;
    notifyListeners();
  }


  void resetOtpRateLimit() {
    _isOtpRateLimited = false;
    notifyListeners();
  }

}