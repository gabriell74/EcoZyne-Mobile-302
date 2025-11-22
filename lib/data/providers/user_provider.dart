import 'package:ecozyne_mobile/data/models/user.dart';
import 'package:ecozyne_mobile/data/services/secure_storage_service.dart';
import 'package:ecozyne_mobile/data/services/user_service.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  bool _isLoading = false;
  bool _success = false;
  String? _message;
  User? _user;
  bool _isGuest = true;

  bool get isLoading => _isLoading;
  bool get success => _success;
  String? get message => _message;
  User? get user => _user;
  bool get isGuest => _isGuest;

  Future<void> fetchCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    final token = await SecureStorageService.getToken();

    if (token == null) {
      _setGuestMode("Guest mode aktif");
      return;
    }

    final result = await _userService.getUserFromToken(token);

    if (result["success"] == true && result["user"] != null) {
      final fetchedUser = result["user"] as User;
      _user = fetchedUser;
      _isGuest = false;
      _success = true;
      _message = null;
    } else {
      _setGuestMode(result["message"] ?? "Guest mode aktif");
    }

    print("STATUS GUEST: $_isGuest");
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await SecureStorageService.deleteToken();
    _setGuestMode("Guest mode aktif");
  }

  /// Helper untuk set state guest mode
  void _setGuestMode(String msg) {
    _user = null;
    _isGuest = true;
    _success = false;
    _message = msg;
    _isLoading = false;
    notifyListeners();
  }
}

