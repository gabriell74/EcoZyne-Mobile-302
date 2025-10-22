import 'package:ecozyne_mobile/data/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationProvider navProvider = context.watch<NavigationProvider>();
    return NavigationBar(
      onDestinationSelected: (value) => navProvider.setIndex(value),
      selectedIndex: navProvider.currentIndex,
      backgroundColor: Colors.white,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: 'Beranda',
          selectedIcon: Icon(Icons.home),
        ),
        const NavigationDestination(
          icon: Icon(Icons.store_outlined),
          label: 'Toko',
          selectedIcon: Icon(Icons.store),
        ),
        const NavigationDestination(
          icon: Icon(Icons.redeem_outlined),
          label: 'Hadiah',
          selectedIcon: Icon(Icons.redeem),
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outlined),
          label: 'Profil',
          selectedIcon: Icon(Icons.person),
        ),
      ],
    );
  }
}
