import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/providers/navigation_provider.dart';
import 'package:ecozyne_mobile/features/profile/widgets/profile_menu_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.read<NavigationProvider>();

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Container(
            color: Colors.grey[50],
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey[100],
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Color(0xFF55C173),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const CustomText(
                        'Domi Imoet',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        'Member Bank Sampah',
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.stars_rounded,
                            color: Color(0xFF55C173),
                            size: 30,
                          ),
                          SizedBox(width: 8),
                          CustomText(
                            '2000',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF55C173),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => navProvider.setIndex(2),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF55C173),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                        ),
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        label: const Text(
                          'Tukar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const ProfileMenuList(),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
