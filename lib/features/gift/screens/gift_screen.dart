import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/gift/widgets/gift_card.dart';
import 'package:ecozyne_mobile/features/gift/widgets/gift_search_bar.dart';
import 'package:flutter/material.dart';

class GiftScreen extends StatelessWidget {
  const GiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {
        'image': 'assets/images/cover1.png',
        'name': 'Beras Premium',
        'poin': '200 poin',
      },
      {
        'image': 'assets/images/cover2.png',
        'name': 'Gula Pasir',
        'poin': '200 poin',
      },
      {
        'image': 'assets/images/cover3.png',
        'name': 'Minyak Goreng',
        'poin': '200 poin',
      },
      {
        'image': 'assets/images/cover1.png',
        'name': 'Sirup Buah',
        'poin': '200 poin',
      },
      {
        'image': 'assets/images/cover3.png',
        'name': 'Minyak Goreng',
        'poin': '200 poin',
      },
      {
        'image': 'assets/images/cover1.png',
        'name': 'Sirup Buah',
        'poin': '200 poin',
      },
      {
        'image': 'assets/images/cover3.png',
        'name': 'Minyak Goreng',
        'poin': '200 poin',
      },
      {
        'image': 'assets/images/cover1.png',
        'name': 'Sirup Buah',
        'poin': '200 poin',
      },
    ];

    return Scaffold(
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: CustomText(
                    "Tukar Poin",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GiftSearchBar()
                ),
              ),

              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final item = products[index];
                    return GiftCard(item: item);
                  },
                  childCount: products.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
