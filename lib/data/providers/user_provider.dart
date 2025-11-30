import 'package:ecozyne_mobile/data/models/community_profile.dart';
import 'package:ecozyne_mobile/data/models/user.dart';
import 'package:ecozyne_mobile/data/services/secure_storage_service.dart';
import 'package:ecozyne_mobile/data/services/user_service.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  bool _isLoading = false;
  bool _success = false;
  String _message = "";
  User? _user;
  bool _isGuest = true;

  bool get isLoading => _isLoading;
  bool get success => _success;
  String get message => _message;
  User? get user => _user;
  bool get isGuest => _isGuest;

  Future<void> fetchCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    final token = await SecureStorageService.getToken();

    if (token == null) {
      _setGuestMode("Guest mode aktif");
      _isLoading = false;
      notifyListeners();
      return;
    }

    final result = await _userService.getUserFromToken(token);

    if (result["type"] == "no_connection") {
      _success = false;
      _message = "NO_CONNECTION";

      _isLoading = false;
      notifyListeners();
      return;
    }

    if (result["type"] == "token_invalid") {
      await SecureStorageService.deleteToken();

      _setGuestMode("Token tidak valid, silakan login kembali");

      _isLoading = false;
      notifyListeners();
      return;
    }

    if (result["type"] == "server_error") {
      _success = false;
      _message = "SERVER_ERROR";
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (result["success"] == true) {
      _user = result["user"];
      _isGuest = false;
      _success = true;
      _message = "User aktif";

      _isLoading = false;
      notifyListeners();
      return;
    }

    _success = false;
    _message = "ERROR_TIDAK_DIKETAHUI";
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUserProfile({
    required String username,
    required String name,
    required String phoneNumber,
    required String email,
    required String address,
    required int kelurahanId,
    required String postalCode,
  }) async {
    _isLoading = true;
    notifyListeners();

    if (_user == null) {
      _isLoading = false;
      _message = "User tidak ditemukan";
      notifyListeners();
      return false;
    }

    final result = await _userService.updateProfile(
      _user!,
      username: username,
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
      kelurahanId: kelurahanId,
      postalCode: postalCode,
    );

    if (!result["success"]) {
      _message = result["message"];
      _isLoading = false;
      notifyListeners();
      return false;
    }

    await fetchCurrentUser();

    _message = result["message"];
    _isLoading = false;
    notifyListeners();
    return true;
  }


  void updateCommunityPoint(int newPoint) {
    if (_user != null) {
      _user!.community.updatePoint(newPoint);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await SecureStorageService.deleteToken();
    _setGuestMode("Guest mode aktif");
  }

  void _setGuestMode(String msg) {
    _user = null;
    _isGuest = true;
    _success = false;
    _message = msg;
    _isLoading = false;
    notifyListeners();
  }
}

