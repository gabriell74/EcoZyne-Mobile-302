import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/activity/widget/activity_card.dart';
import 'package:ecozyne_mobile/features/activity/widget/activity_header.dart';
import 'package:ecozyne_mobile/features/activity/widget/favorite_activity.dart';
import 'package:ecozyne_mobile/features/activity/widget/filter_activity.dart';
import 'package:ecozyne_mobile/features/activity/widget/search_activity.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: CustomText("Kegiatan", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: AppBackground(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchActivity(),

                    const SizedBox(height: 30),

                    ActivityHeader(),

                    const SizedBox(height: 25),

                    const CustomText(
                      "Kegiatan Unggulan",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),

                    const SizedBox(height: 11),

                    FavoriteActivity(),
                    const SizedBox(height: 30),

                    const CustomText(
                      "Jelajahi Kegiatan",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 11),

                    FilterActivity(),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                    right: 5,
                    left: 5,
                  ),
                  child: ActivityCard(),
                );
              }, childCount: 9),
            ),
          ],
        ),
      ),
    );
  }
}
