import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/providers/navigation_provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/profile/widgets/profile_menu_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.read<NavigationProvider>();
    final userProvider = context.watch<UserProvider>();
    final String userName = userProvider.user?.username ?? "Guest";
    final bool isGuest = userProvider.isGuest;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
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
            width: MediaQuery.sizeOf(context).width * 0.7,
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
                CustomText(
                  userName,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                CustomText(
                  isGuest ? 'Tamu' : 'Komunitas',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      color: Color(0xFF55C173),
                      size: 30,
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      isGuest ? '-' : '2000',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF55C173),
                    ),
                  ],
                ),
                if (!isGuest)
                  ElevatedButton.icon(
                    onPressed: () => navProvider.setIndex(2),
                    icon: const Icon(Icons.swap_horiz, size: 18),
                    label: const CustomText(
                      'Tukar',
                      fontWeight: FontWeight.bold,
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
            child: isGuest
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          'Buat akun sekarang!',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF55C173),
                        ),
                        const SizedBox(height: 8),
                        const CustomText(
                          'Daftar akun untuk menikmati semua fitur dan mulai berkontribusi 🌱',
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text("Buat Akun"),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Sudah Punya Akun? ",
                              color: Colors.grey.shade500,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/login'),
                              child: const CustomText(
                                "Login",
                                color: Color(0xFF55C173),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const ProfileMenuList(),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
