import 'package:ecozyne_mobile/features/dashboard/widgets/category_item.dart';
import 'package:flutter/material.dart';

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CategoryItem(
          color: Color(0xFFDC9497), 
          label: "Bank Sampah", 
          icon: Icons.recycling_outlined, 
          onTap: () {},
        ),
        CategoryItem(
            color: Color(0xFF649B71),
            label: "Kegiatan",
            icon: Icons.volunteer_activism_outlined,
            onTap: () {},
        ),
        CategoryItem(
          color: Color(0xFFF5AD7E),
          label: "Forum Diskusi",
          icon: Icons.question_answer_outlined,
          onTap: () {},
        ),
        CategoryItem(
          color: Color(0xFFACA1CD),
          label: "Komik",
          icon: Icons.book_outlined,
          onTap: () {},
        ),
      ],
    );
  }
}
