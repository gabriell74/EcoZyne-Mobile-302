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

  bool get isLoading => _isLoading;
  bool get success => _success;
  String? get message => _message;
  User? get user => _user;

  Future<void> fetchCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    final token = await SecureStorageService.getToken();

    if (token == null) {
      _user = null;
      _success = false;
      _message = "Guest mode aktif";
      _isLoading = false;
      notifyListeners();
      return;
    }

    final result = await _userService.getUserFromToken(token);

    if (result["success"] == true && result["user"] != null) {
      _user = result["user"];
      _success = true;
    } else {
      _user = null;
      _success = false;
      _message = result["message"] ?? "Guest mode aktif";
    }

    print("Data User: $_user");
    print("Token: $token");

    _isLoading = false;
    notifyListeners();
  }
}