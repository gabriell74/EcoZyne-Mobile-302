import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/gift/widgets/gift_card.dart';
import 'package:ecozyne_mobile/features/gift/widgets/gift_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GiftScreen extends StatelessWidget {
  const GiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {
        'image': 'assets/images/gift.png',
        'name': 'Beras Premium',
        'poin': '200 poin',
      },
      {
        'image': 'assets/images/gift2.png',
        'name': 'Gula Pasir Pantai Putih Seputih Kertas Panjang Sekali',
        'poin': '250 poin',
      },
      {
        'image': 'assets/images/gift3.png',
        'name': 'Minyak Goreng',
        'poin': '150 poin',
      },
      {
        'image': 'assets/images/gift4.png',
        'name': 'Sirup Buah Lezat dengan Botol Cantik',
        'poin': '300 poin',
      },
    ];

    return Scaffold(
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(8),
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

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: GiftSearchBar(),
                ),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: CustomText(
                    "Temukan hadiah menarik",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 2,
                childCount: products.length,
                itemBuilder: (context, index) {
                  return GiftCard(item: products[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
