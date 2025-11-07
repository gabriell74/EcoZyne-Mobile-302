import 'package:ecozyne_mobile/features/dashboard/widgets/category_item.dart';
import 'package:flutter/material.dart';

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'color': Color.fromARGB(255, 86, 178, 91),
        'label': "Eco Bank",
        'icon': Icons.recycling_outlined,
        'onTap': () {
          Navigator.pushNamed(context, '/waste-bank');
        },
      },
      {
        'color': Color.fromARGB(255, 230, 89, 73),
        'label': "Kegiatan",
        'icon': Icons.volunteer_activism_outlined,
        'onTap': () {
          Navigator.pushNamed(context, '/activity');
        },
      },
      {
        'color': Color(0xFF64B5F6),
        'label': "Forum Diskusi",
        'icon': Icons.question_answer_outlined,
        'onTap': () {
          Navigator.pushNamed(context, '/discussion-forum');
        },
      },
      {
        'color': Color(0xFFBA68C8),
        'label': "Komik",
        'icon': Icons.book_outlined,
        'onTap': () {
          Navigator.pushNamed(context, '/comic');
        },
      },
      {
        'color': Color.fromARGB(255, 109, 77, 182),
        'label': "Setoran",
        'icon': Icons.upload,
        'onTap': () {
          Navigator.pushNamed(context, '/waste-bank-deposit');
        },
      },
      {
        'color': Color(0xFFFF8A65),
        'label': "Pesanan",
        'icon': Icons.receipt_long,
        'onTap': () {
          Navigator.pushNamed(context, '/order');
        },
      },
      {
        'color': Color(0xFFF48FB1),
        'label': "Tracking",
        'icon': Icons.hourglass_bottom_rounded,
        'onTap': () {
          Navigator.pushNamed(context, '/eco-enzyme-tracking');
        },
      },
      {
        'color': Colors.orange,
        'label': "Kelola Produk",
        'icon': Icons.shopping_bag_outlined,
        'onTap': () {
          Navigator.pushNamed(context, '/manage-product');
        },
      },
      {
        'color': Colors.teal,
        'label': "Eco Kalkulator",
        'icon': Icons.calculate_outlined,
        'onTap': () {
          Navigator.pushNamed(context, '/eco-calculator');
        },
      },
      {
        'color': Color(0xFF9B9B9B),
        'label': "Riwayat",
        'icon': Icons.history, 
        'onTap': () {
          Navigator.pushNamed(context, '/history');
        },
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
