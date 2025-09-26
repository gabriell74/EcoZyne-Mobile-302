import 'package:ecozyne_mobile/core/widgets/bottom_navbar.dart';
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
    NavigationProvider _navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomNavBar(),
      body: _screens[_navProvider.currentIndex],
    );
  }
}
