import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/data/models/user.dart';
import 'package:ecozyne_mobile/data/providers/navigation_provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/profile/screens/edit_account_screen.dart';
import 'package:ecozyne_mobile/features/profile/widgets/profile_menu_item.dart';
import 'package:ecozyne_mobile/features/waste_bank/screens/waste_bank_register_screen.dart';
import 'package:ecozyne_mobile/features/waste_bank/screens/waste_bank_submission_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    String userRole = context.read<UserProvider>().user!.role;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        if (userRole == "community")
          ProfileMenuItem(
            icon: Icons.recycling_outlined,
            label: "Daftar Menjadi Bank Sampah",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WasteBankRegisterScreen(),
                ),
              );
            },
          ),

        ProfileMenuItem(
          icon: Icons.pending_actions,
          iconColor: Colors.indigo,
          label: "Riwayat Pengajuan Bank Sampah",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WasteBankSubmissionHistoryScreen(),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            color: Colors.grey.withValues(alpha: 0.2),
            thickness: 1,
            height: 1,
          ),
        ),
        ProfileMenuItem(
          iconColor: Colors.purpleAccent,
          icon: Icons.person_outline_rounded,
          label: "Edit Akun",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditAccountScreen()),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            color: Colors.grey.withValues(alpha: 0.2),
            thickness: 1,
            height: 1,
          ),
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
    final userProvider = context.read<UserProvider>();
    final navProvider = context.read<NavigationProvider>();

    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        "Apakah Anda yakin ingin keluar dari akun?",
        onTap: () async {
          Navigator.of(context).pop();
          await userProvider.logout();
          navProvider.setIndex(0);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/get_started',
            (route) => false,
          );
        },
      ),
    );
  }
}
