import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/marketplace/widgets/marketplace_card.dart';
import 'package:ecozyne_mobile/features/marketplace/widgets/marketplace_search_bar.dart';
import 'package:flutter/material.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {
        'image': 'assets/images/cover1.png',
        'name': 'Pupuk Kompos',
        'price': 'Rp 10.000',
      },
      {
        'image': 'assets/images/cover2.png'    ,
        'name': 'Bibit Cabai',
        'price': 'Rp 15.000',
      },
      {
        'image': 'assets/images/cover3.png',
        'name': 'Tanah Subur',
        'price': 'Rp 12.000',
      },
      {
        'image': 'assets/images/cover1.png',
        'name': 'Pupuk Cair',
        'price': 'Rp 20.000',
      },
      {
        'image': 'assets/images/cover1.png',
        'name': 'Pupuk Cair',
        'price': 'Rp 20.000',
      },
      {
        'image': 'assets/images/cover1.png',
        'name': 'Pupuk Cair',
        'price': 'Rp 20.000',
      },
    ];

    return Scaffold(
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CustomText(
                    "Marketplace",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: MarketplaceSearchBar()
                ),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CustomText(
                    "Produk Eco Enzyme",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = products[index];
                    return MarketplaceCard(item: item);
                  },
                  childCount: products.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
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
