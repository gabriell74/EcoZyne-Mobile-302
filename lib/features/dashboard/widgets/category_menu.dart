import 'dart:ui';
import 'package:ecozyne_mobile/core/utils/user_helper.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final isCommunity = user?.role == "community";
    final isLoggedIn = UserHelper.isLoggedIn(context);

    // Menu restricted terkunci jika:
    // 1. Belum login (!isLoggedIn) ATAU
    // 2. Sudah login tapi role community (isCommunity)
    final shouldLockRestricted = !isLoggedIn || isCommunity;

    List<Map<String, dynamic>> allMenus = [
      {
        'color': Color.fromARGB(255, 86, 178, 91),
        'label': "Eco Bank",
        'icon': Icons.recycling_outlined,
        'onTap': () => Navigator.pushNamed(context, '/waste-bank'),
        'isRestricted': false,
      },
      {
        'color': Color.fromARGB(255, 230, 89, 73),
        'label': "Kegiatan",
        'icon': Icons.volunteer_activism_outlined,
        'onTap': () => Navigator.pushNamed(context, '/activity'),
        'isRestricted': false,
      },
      {
        'color': Color(0xFF64B5F6),
        'label': "Forum Diskusi",
        'icon': Icons.question_answer_outlined,
        'onTap': () => Navigator.pushNamed(context, '/discussion-forum'),
        'isRestricted': false,
      },
      {
        'color': Color(0xFFBA68C8),
        'label': "Komik",
        'icon': Icons.book_outlined,
        'onTap': () => Navigator.pushNamed(context, '/comic'),
        'isRestricted': false,
      },
      {
        'color': Colors.teal,
        'label': "Eco Kalkulator",
        'icon': Icons.calculate_outlined,
        'onTap': () => Navigator.pushNamed(context, '/eco-calculator'),
        'isRestricted': false,
      },
      {
        'color': Color(0xFF9B9B9B),
        'label': "Riwayat",
        'icon': Icons.history,
        'onTap': () => !isLoggedIn ? null : Navigator.pushNamed(context, '/history'),
        'isRestricted': !isLoggedIn ? true : false,
      },
      {
        'color': Colors.green,
        'label': "Setoran",
        'icon': Icons.upload,
        'onTap': shouldLockRestricted ? null : () => Navigator.pushNamed(context, '/waste-bank-deposit'),
        'isRestricted': true,
      },
      {
        'color': Colors.orange,
        'label': "Pesanan",
        'icon': Icons.receipt_long,
        'onTap': shouldLockRestricted ? null : () => Navigator.pushNamed(context, '/order'),
        'isRestricted': true,
      },
      {
        'color': Colors.purple,
        'label': "Tracking",
        'icon': Icons.hourglass_bottom_rounded,
        'onTap': shouldLockRestricted ? null : () => Navigator.pushNamed(context, '/eco-enzyme-tracking'),
        'isRestricted': true,
      },
      {
        'color': Colors.teal,
        'label': "Kelola Produk",
        'icon': Icons.shopping_bag_outlined,
        'onTap': shouldLockRestricted ? null : () => Navigator.pushNamed(context, '/manage-product'),
        'isRestricted': true,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: allMenus.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.85,
            mainAxisSpacing: 4,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (_, i) {
            final item = allMenus[i];
            final isRestricted = item['isRestricted'] as bool;
            final isLocked = isRestricted && shouldLockRestricted;

            return CategoryItem(
              color: item['color'] as Color,
              icon: item['icon'] as IconData,
              label: item['label'] as String,
              onTap: item['onTap'] as VoidCallback?,
              isLocked: isLocked,
            );
          },
        ),

        if (shouldLockRestricted)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.green.shade100,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_open_outlined,
                        size: 20,
                        color: Color(0xFF55C173),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              !isLoggedIn
                                  ? "Login untuk mengakses fitur"
                                  : "Buka Fitur Bank Sampah",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF55C173),
                            ),
                            const SizedBox(height: 2),
                            CustomText(
                              !isLoggedIn
                                  ? "Akses semua fitur eksklusif"
                                  : "Akses 4 fitur eksklusif",
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isLoggedIn) {
                        Navigator.pushNamed(context, '/login');
                      } else {
                        Navigator.pushNamed(context, '/waste-bank-register');
                      }
                    },
                    child: CustomText(
                      !isLoggedIn ? "Login" : "Daftar",
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}