import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? emailError;
  String? passwordError;

  bool validateEmail(String email) {
    if(!Validators.isValidEmail(email)) {
      emailError = 'Email tidak valid';
      notifyListeners();
      return false;
    }
    emailError = null;
    notifyListeners();
    return true;
  }

  bool validatePassword(String password) {
    if(password.length < 8) {
      passwordError = 'Password kurang dari 8 karakter';
      notifyListeners();
      return false;
    }
    passwordError = null;
    notifyListeners();
    return true;
  }

  bool validateEmailPassword(email, password) {
    final emailValid = validateEmail(email);
    final passwordValid = validatePassword(password);
    return emailValid && passwordValid;
  }
}