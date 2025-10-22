import 'package:ecozyne_mobile/features/activity/screens/activity_screen.dart';
import 'package:ecozyne_mobile/features/articles/screens/articles_screen.dart';
import 'package:ecozyne_mobile/features/authentication/screens/register_screen.dart';
import 'package:ecozyne_mobile/features/authentication/screens/login_screen.dart';
import 'package:ecozyne_mobile/features/dashboard/screens/dashboard_screen.dart';
import 'package:ecozyne_mobile/features/discussion_forum/screens/discussion_forum_screen.dart';
import 'package:ecozyne_mobile/features/discussion_forum/screens/question_screen.dart';
import 'package:ecozyne_mobile/features/eco_enzyme_calculator/screens/eco_enzyme_calculator_screen.dart';
import 'package:ecozyne_mobile/features/get_started_screen.dart';
import 'package:ecozyne_mobile/features/gift/screens/gift_screen.dart';
import 'package:ecozyne_mobile/features/order/screens/order_screen.dart';
import 'package:ecozyne_mobile/features/waste_bank/screens/waste_bank_screen.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/waste_bank_card.dart';
import 'package:ecozyne_mobile/features/waste_deposit/screens/waste_deposit_screen.dart';
import 'package:ecozyne_mobile/features/waste_deposit/screens/waste_detail.dart';
import 'package:ecozyne_mobile/features/home.dart';
// import 'package:ecozyne_mobile/features/get_started_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String getStarted = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String wasteDetail = '/waste-detail';
  static const String dashboard = '/dashboard';
  static const String articles = '/articles';
  static const String activity = '/activity';
  static const String discussionForum = '/discussion-forum';
  static const String question = '/question';
  static const String gift = '/gift';
  static const String wasteBank = '/waste-bank';
  static const String wasteBankCard = '/waste-bank-card';
  static const String wasteBankDeposit = '/waste-bank-deposit';
  static const String ecoCalculator = '/eco-calculator';
  static const String order = '/order';
  // static const String discussionComen = '/discussion-comen';

  static Map<String, WidgetBuilder> routes = {
    getStarted: (context) => GetStartedScreen(),
    home: (context) => HomeScreen(),
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    wasteDetail: (context) => WasteDetailScreen(),
    dashboard: (context) => DashboardScreen(),
    articles: (context) => ArticlesScreen(),
    activity: (context) => ActivityScreen(),
    discussionForum: (context) => DiscussionForumScreen(),
    question: (context) => QuestionScreen(),
    gift: (context) => GiftScreen(),
    wasteBank: (context) => WasteBankScreen(),
    wasteBankCard: (context) => WasteBankCard(),
    wasteBankDeposit: (context) => WasteDepositScreen(),
    ecoCalculator: (context) => EcoEnzymeCalculatorScreen(),
    order: (context) => OrderScreen(),
    // discussionComen: (context) => DiscussionComen(),
  };
}
