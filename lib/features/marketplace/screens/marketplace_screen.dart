import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/marketplace/widgets/marketplace_card.dart';
import 'package:ecozyne_mobile/features/marketplace/widgets/marketplace_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {
        'image': 'assets/images/product.png',
        'name': 'Pupuk Kompos, Bibit Cabai, dan Tanah Subur',
        'price': 'Rp 10.000',
      },
      {
        'image': 'assets/images/product2.png'    ,
        'name': 'Bibit Cabai',
        'price': 'Rp 15.000',
      },
      {
        'image': 'assets/images/product3.png',
        'name': 'Tanah Subur',
        'price': 'Rp 12.000',
      },
      {
        'image': 'assets/images/product4.png',
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

              SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 2,
                childCount: products.length,
                itemBuilder: (context, index) {
                  return MarketplaceCard(item: products[index]);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
