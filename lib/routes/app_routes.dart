import 'package:ecozyne_mobile/features/authentication/screens/register_screen.dart';
import 'package:ecozyne_mobile/features/authentication/screens/login_screen.dart';
import 'package:ecozyne_mobile/features/waste_deposit/screens/waste_detail.dart';
import 'package:flutter/foundation.dart';
// import 'package:ecozyne_mobile/features/get_started_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // static const String getStarted = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String wasteDetail = '/waste-detail';

  static Map<String, WidgetBuilder> routes = {
    // getStarted: (context) => GetStartedScreen(),
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    wasteDetail: (context) => WasteDetailScreen(),
  };
}
