import 'package:ecozyne_mobile/features/activity/screens/activity_screen.dart';
import 'package:ecozyne_mobile/features/articles/screens/articles_screen.dart';
import 'package:ecozyne_mobile/features/authentication/screens/register_screen.dart';
import 'package:ecozyne_mobile/features/authentication/screens/login_screen.dart';
import 'package:ecozyne_mobile/features/dashboard/screens/dashboard_screen.dart';
import 'package:ecozyne_mobile/features/waste_deposit/screens/waste_detail.dart';
import 'package:ecozyne_mobile/features/home.dart';
// import 'package:ecozyne_mobile/features/get_started_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // static const String getStarted = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String wasteDetail = '/waste-detail';
  static const String dashboard = 'dashboard';
  static const String articles = '/articles';
  static const String activity = '/activity';

  static Map<String, WidgetBuilder> routes = {
    // getStarted: (context) => GetStartedScreen(),
    home: (context) => HomeScreen(),
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    wasteDetail: (context) => WasteDetailScreen(),
    dashboard: (context) => DashboardScreen(),
    articles: (context) => ArticlesScreen(),
    activity: (context) => ActivityScreen(),
  };
}
