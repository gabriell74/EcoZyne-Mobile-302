import 'package:ecozyne_mobile/core/utils/user_helper.dart';
import 'package:ecozyne_mobile/core/widgets/animated_gradient_text.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/bottom_navbar.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/dashboard/screens/dashboard_screen.dart';
import 'package:ecozyne_mobile/features/gift/screens/gift_screen.dart';
import 'package:ecozyne_mobile/features/marketplace/screens/marketplace_screen.dart';
import 'package:ecozyne_mobile/features/profile/screens/account_screen.dart';
import 'package:ecozyne_mobile/data/providers/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(),
      MarketplaceScreen(),
      GiftScreen(),
      AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final navProvider = context.watch<NavigationProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        shadowColor: Colors.grey.withValues(alpha: 0.5),
        actions: [
          CustomText(
            UserHelper.isLoggedIn(context)
                ? userProvider.user!.communityPoint.toString()
                : "0",
            color: Colors.amber[800],
          ),
          const SizedBox(width: 10),
          Icon(Icons.stars_rounded, color: Colors.amber[800]),
          const SizedBox(width: 20),
        ],
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 1),
              child: Image.asset("assets/images/logo.png", width: 40),
            ),
            AnimatedGradientText(
              "Eco Enzyne",
              colors: [Colors.green, Colors.blue],
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      body: AppBackground(
        child: _screens[navProvider.currentIndex],
      ),
    );
  }
}