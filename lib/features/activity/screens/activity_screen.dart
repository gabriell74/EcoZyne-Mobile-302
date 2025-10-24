import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/activity/widget/activity_card.dart';
import 'package:ecozyne_mobile/features/activity/widget/activity_header.dart';
import 'package:ecozyne_mobile/features/activity/widget/favorite_activity.dart';
import 'package:ecozyne_mobile/features/activity/widget/filter_activity.dart';
import 'package:ecozyne_mobile/features/activity/widget/search_activity.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {

  final List<Map<String, dynamic>> _activities = [
    {
      "image": "assets/images/activity.png",
      "title": "Tanam Pohon Bersama",
      "location": "Batu Aji",
      "date": "12 Agustus 2025, 14.30",
      "quota": "50/200",
    },
    {
      "image": "assets/images/activity2.png",
      "title": "Beach-bersih Pantai Ocarina",
      "location": "Nongsa",
      "date": "18 Agustus 2025, 09.00",
      "quota": "100/100",
    },
    {
      "image": "assets/images/activity3.png",
      "title": "Workshop Eco Enzyme",
      "location": "Tembesi",
      "date": "20 Agustus 2025, 13.00",
      "quota": "10/100",
    },
    {
      "image": "assets/images/activity4.png",
      "title": "Kampanye Pengurangan Plastik",
      "location": "Politeknik Batam",
      "date": "25 Agustus 2025, 10.00",
      "quota": "67/70",
    },
    {
      "image": "assets/images/activity5.png",
      "title": "Donasi Bibit Pohon",
      "location": "Mata Kucing",
      "date": "30 Agustus 2025, 08.30",
      "quota": "30/80",
    }
  ];

  ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: CustomText("Kegiatan", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: CustomScrollView(
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
                  FavoriteActivity(activity: _activities[1]),
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
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final activity = _activities[index];
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  right: 5,
                  left: 5,
                ),
                child: ActivityCard(activity: activity,),
              );
            }, childCount: _activities.length),
          ),
        ],
      ),
    );
  }
}
