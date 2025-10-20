import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/providers/auth_provider.dart';
import 'package:ecozyne_mobile/data/providers/navigation_provider.dart';
import 'package:ecozyne_mobile/features/profile/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileMenuList extends StatelessWidget {

  const ProfileMenuList({super.key,});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProfileMenuItem(
          icon: Icons.person,
          label: "Edit Akun",
          onTap: () {}
        ),
        Divider(height: 1, color: Colors.grey[300]),
        ProfileMenuItem(
            icon: Icons.exit_to_app,
            label: "Keluar",
            onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    AuthProvider authProvider = context.read<AuthProvider>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Keluar"),
          content: const Text("Apakah Anda yakin ingin keluar?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const CustomText(
                "Keluar",
                color: Colors.red,
              ),
              onPressed: () async {
                await authProvider.logout();
                context.read<NavigationProvider>().setIndex(0);
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
