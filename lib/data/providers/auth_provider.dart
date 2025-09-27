import 'package:ecozyne_mobile/data/models/user.dart';
import 'package:ecozyne_mobile/data/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.login(email, password);

    if (result["success"]) {
      _user = result["user"] as User;
      _errorMessage = null;
    } else {
      _user = null;
      _errorMessage = result["message"];
    }

    _isLoading = false;
    notifyListeners();
  }
}