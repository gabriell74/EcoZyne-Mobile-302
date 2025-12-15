import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/slide_fade_in.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/marketplace_provider.dart';
import 'package:ecozyne_mobile/features/marketplace/widgets/marketplace_card.dart';
import 'package:ecozyne_mobile/features/marketplace/widgets/marketplace_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _query = "";

  // Future<void> _showConfirmDialog(
  //     BuildContext context,
  //     int quantity,
  //     Reward reward,
  //     ) async {
  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder: (confirmDialogContext) => ConfirmationDialog(
  //       "Apakah anda yakin menukar produk ini?",
  //       onTap: () {
  //         Navigator.pop(confirmDialogContext, true);
  //       },
  //     ),
  //   );
  //
  //   if (confirmed != true) return;
  //
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (loadingContext) => const LoadingWidget(height: 100),
  //   );
  //
  //   final userProvider = context.read<UserProvider>();
  //   final rewardProvider = context.read<RewardProvider>();
  //   final success = await rewardProvider.rewardExchange(
  //     quantity,
  //     reward.id,
  //     reward.unitPoint * quantity,
  //     userProvider,
  //   );
  //
  //   if (context.mounted) {
  //     Navigator.pop(context);
  //   }
  //
  //   if (success) {
  //     showSuccessTopSnackBar(
  //       context,
  //       "Pesanan Sedang Diproses",
  //       icon: const Icon(Icons.shopping_bag),
  //     );
  //     Navigator.pop(context);
  //   } else {
  //     showErrorTopSnackBar(
  //       context,
  //       rewardProvider.message,
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketplaceProvider>().getProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              await context.read<MarketplaceProvider>().getProduct(forceRefresh: true);
            },
            color: Colors.black,
            backgroundColor: const Color(0xFF55C173),
            child: CustomScrollView(
              key: PageStorageKey('marketplace_scroll'),
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CustomText(
                      "Katalog Produk",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Search bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: MarketplaceSearchBar(
                      onSearch: (query) {
                        setState(() {
                          _query = query;
                        });
                      },
                    )
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

                Consumer<MarketplaceProvider>(
                  builder: (context, provider, _) {
                    final products = provider.products;

                    final filtered = _query.isEmpty
                        ? products
                        : products
                        .where((p) => p.productName.toLowerCase().contains(_query.toLowerCase()))
                        .toList();

                    if (provider.isLoading) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: LoadingWidget()),
                      );
                    }

                    if (provider.products.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: EmptyState(
                            connected: provider.connected,
                            message: provider.message,
                          ),
                        ),
                      );
                    }

                    if (filtered.isEmpty) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: EmptyState(
                            connected: true,
                            message: "Hadiah tidak ditemukan.",
                          ),
                        ),
                      );
                    }

                      return SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 2,
                      childCount: filtered.length,
                      itemBuilder: (context, index) {
                        final product = filtered[index];

                        return MarketplaceCard(product: product,);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
