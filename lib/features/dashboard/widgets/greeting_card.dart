import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GreetingCard extends StatelessWidget {

  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    final String userName = user?.username ?? "Guest";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco_rounded,
              color: Color(0xFF4CAF50),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Halo, $userName!",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                ),
                const SizedBox(height: 4),
                CustomText(
                  user == null
                      ? "Selamat datang di Ecozyne! Buat akunmu sekarang untuk menikmati semua fitur kami 🌱"
                      : "Selamat datang kembali, $userName! Yuk lanjutkan kontribusimu hari ini",
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.3,
                ),
                if (user == null) ...[
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text("Masuk Akun"),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
