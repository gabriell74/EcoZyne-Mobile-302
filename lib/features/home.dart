import 'package:ecozyne_mobile/core/widgets/animated_gradient_text.dart';
import 'package:ecozyne_mobile/core/widgets/bottom_navbar.dart';
import 'package:ecozyne_mobile/core/widgets/floating_logo.dart';
import 'package:ecozyne_mobile/features/dashboard/screens/dashboard_screen.dart';
import 'package:ecozyne_mobile/features/gift/screens/gift_screen.dart';
import 'package:ecozyne_mobile/features/marketplace/screens/marketplace_screen.dart';
import 'package:ecozyne_mobile/features/profile/screens/profile_screen.dart';
import 'package:ecozyne_mobile/data/providers/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> _screens = [
    DashboardScreen(),
    MarketplaceScreen(),
    GiftScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final NavigationProvider navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/images/logo.png"),
        elevation: 1,
        shadowColor: Colors.grey.withValues(alpha: 0.5),
        title: AnimatedGradientText(
          "Eco Enzyne",
          colors: [Colors.green, Colors.blue],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      body: _screens[navProvider.currentIndex],
    );
  }
}
