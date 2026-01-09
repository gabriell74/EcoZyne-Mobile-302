import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:ecozyne_mobile/data/services/forgot_password_service.dart';
import 'package:flutter/material.dart';

class ForgotPasswordProvider with ChangeNotifier {
  final ForgotPasswordService _forgotPasswordService =
  ForgotPasswordService();

  bool _isLoading = false;
  bool _success = false;
  String? _message;

  bool _connected = true;
  bool get connected => _connected;

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

  Future<bool> sendResetPasswordOtp({
    required String email,
  }) async {
    _isLoading = true;
    _success = false;
    _message = null;
    notifyListeners();

    final result =
    await _forgotPasswordService.sendResetPasswordOtp(email: email);

    if (result['success'] == true) {
      Validators.clearServerErrors();
      _success = true;
      _message = result['message'] ?? 'OTP berhasil dikirim';
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _success = false;

      if (result['errors'] != null) {
        Validators.setServerErrors(result['errors']);
        _message = result['message'] ?? 'Validasi gagal';
      } else {
        Validators.clearServerErrors();
        _message = result['message'] ?? 'Gagal mengirim OTP';
      }

      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    _isOtpLoading = true;
    _success = false;
    _message = null;
    notifyListeners();

    final result =
    await _forgotPasswordService.verifyResetPasswordOtp(
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

  Future<void> resendResetPasswordOtp({
    required String email,
  }) async {
    _isResendOtpLoading = true;
    _message = null;
    notifyListeners();

    final result =
    await _forgotPasswordService.resendResetPasswordOtp(
      email: email,
    );

    if (result['success'] == true) {
      _message = result['message'] ?? 'OTP berhasil dikirim ulang';

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

  Future<bool> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _isLoading = true;
    _success = false;
    _message = null;
    notifyListeners();

    final result = await _forgotPasswordService.resetPassword(
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    _connected = result["connected"] ?? false;

    if (result['success'] == true) {
      Validators.clearServerErrors();
      _success = true;
      _message = result['message'] ?? 'Password berhasil direset';

      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _success = false;

      if (result['errors'] != null) {
        Validators.setServerErrors(result['errors']);
        _message = result['message'] ?? 'Validasi gagal';
      } else {
        Validators.clearServerErrors();
        _message = result['message'] ?? 'Reset password gagal';
      }

      _isLoading = false;
      notifyListeners();
      return false;
    }
  }


  void resetOtpRateLimit() {
    _isOtpRateLimited = false;
    notifyListeners();
  }
}
