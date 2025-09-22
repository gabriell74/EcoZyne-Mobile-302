import 'package:ecozyne_mobile/features/authentication/screens/register_screen.dart';
import 'package:ecozyne_mobile/features/authentication/screens/login_screen.dart';
// import 'package:ecozyne_mobile/features/get_started_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // static const String getStarted = '/';
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> routes = {
    // getStarted: (context) => GetStartedScreen(),
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
  };
}
