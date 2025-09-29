import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/article_list.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/carousel_video.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/category_menu.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 15),

            const CarouselVideo(),

            const SizedBox(height: 15),

            const CustomText(
              "Menu Navigasi",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),

            const SizedBox(height: 15),

            const CategoryMenu(),

            ArticleList(),
          ],
        ),
      ),
    );
  }
}
