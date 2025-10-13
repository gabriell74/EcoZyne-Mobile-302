import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/providers/auth_provider.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/article_list.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/greeting_card.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/carousel_video.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/category_menu.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/latest_activity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // String authName = context.read<AuthProvider>().user!.username;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 5),

            GreetingCard(username: "Vio"),

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

            LatestActivity(),

            const Divider(),

            const SizedBox(height: 10),

            const ArticleList(),

          ],
        ),
      ),
    );
  }
}
