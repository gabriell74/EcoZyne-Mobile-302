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
      "currentQuota": 50,
      "maxQuota": 200,
      "location": "Batu Aji",
      "startDate": "12 Agustus 2025, 08.00",
      "dueDate": "12 Agustus 2025, 12.00",
      "description":
          "Ikut serta dalam kegiatan menanam pohon untuk menghijaukan lingkungan dan mengurangi polusi udara.",
    },
    {
      "image": "assets/images/activity2.png",
      "title": "Beach-bersih Pantai Ocarina",
      "currentQuota": 100,
      "maxQuota": 100,
      "location": "Nongsa",
      "startDate": "18 Agustus 2025, 09.00",
      "dueDate": "18 Agustus 2025, 12.00",
      "description":
          "Aksi bersih pantai bersama komunitas untuk menjaga kebersihan laut dan pantai dari sampah plastik.",
    },
    {
      "image": "assets/images/activity3.png",
      "title": "Workshop Eco Enzyme",
      "currentQuota": 10,
      "maxQuota": 100,
      "location": "Tembesi",
      "startDate": "20 Agustus 2025, 13.00",
      "dueDate": "20 Agustus 2025, 16.00",
      "description":
          "Pelajari cara membuat Eco Enzyme dari limbah organik rumah tangga untuk solusi ramah lingkungan.",
    },
    {
      "image": "assets/images/activity4.png",
      "title": "Kampanye Pengurangan Plastik",
      "currentQuota": 67,
      "maxQuota": 70,
      "location": "Politeknik Batam",
      "startDate": "25 Agustus 2025, 10.00",
      "dueDate": "25 Agustus 2025, 14.00",
      "description":
          "Kampanye edukatif untuk mengurangi penggunaan plastik sekali pakai di lingkungan kampus dan sekitarnya.",
    },
    {
      "image": "assets/images/activity5.png",
      "title": "Donasi Bibit Pohon",
      "currentQuota": 30,
      "maxQuota": 80,
      "location": "Mata Kucing",
      "startDate": "30 Agustus 2025, 08.30",
      "dueDate": "30 Agustus 2025, 12.30",
      "description":
          "Berpartisipasi dalam program donasi bibit pohon untuk penghijauan area sekitar dan konservasi alam.",
    },
  ];

  ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: CustomText("Kegiatan"),
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
                padding: const EdgeInsets.only(bottom: 16.0, right: 5, left: 5),
                child: ActivityCard(activity: activity),
              );
            }, childCount: _activities.length),
          ),
        ],
      ),
    );
  }
}
