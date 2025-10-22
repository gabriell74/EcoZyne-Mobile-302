import 'package:ecozyne_mobile/features/dashboard/widgets/category_item.dart';
import 'package:ecozyne_mobile/features/waste_bank/screens/waste_bank_screen.dart';
import 'package:flutter/material.dart';

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'color': Color(0xFF81C784), // hijau segar
        'label': "Bank Sampah",
        'icon': Icons.recycling_outlined,
        'onTap': () {
          Navigator.pushNamed(context, '/waste-bank');
        },
      },
      {
        'color': Color(0xFFFFB74D), // oranye hangat
        'label': "Kegiatan",
        'icon': Icons.volunteer_activism_outlined,
        'onTap': () {
          Navigator.pushNamed(context, '/activity');
        },
      },
      {
        'color': Color(0xFF64B5F6), // biru muda cerah
        'label': "Forum Diskusi",
        'icon': Icons.question_answer_outlined,
        'onTap': () {
          Navigator.pushNamed(context, '/discussion-forum');
        },
      },
      {
        'color': Color(0xFFBA68C8), // ungu lembut
        'label': "Komik",
        'icon': Icons.book_outlined,
        'onTap': () {},
      },
      {
        'color': Color(0xFF4DB6AC), // toska
        'label': "Setoran",
        'icon': Icons.upload,
        'onTap': () {},
      },
      {
        'color': Color(0xFFFF8A65), // oranye muda
        'label': "Pesanan",
        'icon': Icons.receipt_long,
        'onTap': () {},
      },
      {
        'color': Color(0xFFF48FB1), // hijau muda untuk tracking
        'label': "Tracking",
        'icon': Icons.hourglass_bottom_rounded,
        'onTap': () {},
      },
      {
        'color': Color(0xFF9E9E9E), // abu netral
        'label': "Riwayat",
        'icon': Icons.history,
        'onTap': () {},
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) {
        final item = categories[index];
        return Column(
          children: [
            CategoryItem(
              color: item['color'],
              label: item['label'],
              icon: item['icon'],
              onTap: item['onTap'],
            ),
          ],
        );
      },
    );
  }
}
