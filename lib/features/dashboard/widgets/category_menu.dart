import 'package:ecozyne_mobile/features/dashboard/widgets/category_item.dart';
import 'package:ecozyne_mobile/features/waste_bank/screens/waste_bank_screen.dart';
import 'package:flutter/material.dart';

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'color': Color(0xFFDC9497),
        'label': "Bank Sampah",
        'icon': Icons.recycling_outlined,
        'onTap': () {
          Navigator.pushNamed(context, '/waste-bank');
        },
      },
      {
        'color': Color(0xFF55C173),
        'label': "Kegiatan",
        'icon': Icons.volunteer_activism_outlined,
        'onTap': () {
          Navigator.pushNamed(context, '/activity');
        },
      },
      {
        'color': Color(0xFFF5AD7E),
        'label': "Forum Diskusi",
        'icon': Icons.question_answer_outlined,
        'onTap': () {
          Navigator.pushNamed(context, '/discussion-forum');
        },
      },
      {
        'color': Color(0xFFACA1CD),
        'label': "Komik",
        'icon': Icons.book_outlined,
        'onTap': () {},
      },
      {
        'color': Colors.cyan,
        'label': "Setoran",
        'icon': Icons.upload,
        'onTap': () {},
      },
      {
        'color': Colors.pinkAccent,
        'label': "Pesanan",
        'icon': Icons.receipt_long,
        'onTap': () {},
      },
      {
        'color': Colors.blueGrey,
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
