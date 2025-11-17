import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/article_list.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/greeting_card.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/carousel_video.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/category_menu.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/latest_activity.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final Map<String, dynamic> _activities =
    {
      "image": "assets/images/activity.png",
      "title": "Tanam Pohon Bersama",
      "currentQuota": 50,
      "maxQuota": 200,
      "location": "Batu Aji",
      "startDate": "12 Agustus 2025, 08.00",
      "dueDate": "12 Agustus 2025, 12.00",
      "description": "Ikut serta dalam kegiatan menanam pohon untuk menghijaukan lingkungan dan mengurangi polusi udara."
    };

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 5),

            GreetingCard(),

            const CarouselVideo(),

            const SizedBox(height: 15),

            const CustomText(
              "Menu Navigasi",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),

            const SizedBox(height: 15),

            const CategoryMenu(),

            const Divider(),

            const SizedBox(height: 10),

            LatestActivity(activity: _activities),

            const SizedBox(height: 10),

            ArticleList(),

          ],
        ),
      ),
    );
  }
}
