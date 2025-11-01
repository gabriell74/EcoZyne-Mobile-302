import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/data/providers/auth_provider.dart';
import 'package:ecozyne_mobile/data/providers/navigation_provider.dart';
import 'package:ecozyne_mobile/features/profile/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileMenuItem(
          icon: Icons.person_outline_rounded,
          label: "Edit Akun",
          onTap: () {},
        ),
        ProfileMenuItem(
          icon: Icons.exit_to_app_rounded,
          label: "Keluar",
          iconColor: Colors.red[400],
          isLast: true,
          onTap: () => _showConfirmDialog(context),
        ),
      ],
    );
  }

  void _showConfirmDialog(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final navProvider = context.read<NavigationProvider>();

    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        "Apakah Anda yakin ingin keluar dari akun?",
        onTap: () async {
          Navigator.of(context).pop();
          await authProvider.logout();
          navProvider.setIndex(0);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        },
      ),
    );
  }
}
