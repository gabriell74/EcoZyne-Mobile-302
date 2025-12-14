import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/models/reward.dart';
import 'package:ecozyne_mobile/data/providers/reward_provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/gift/screens/gift_exchange_screen.dart';
import 'package:ecozyne_mobile/features/gift/widgets/gift_card.dart';
import 'package:ecozyne_mobile/features/gift/widgets/gift_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class GiftScreen extends StatefulWidget {
  const GiftScreen({super.key});

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  String _query = "";

  Future<void> _showConfirmDialog(
      BuildContext context,
      int quantity,
      Reward reward,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (confirmDialogContext) => ConfirmationDialog(
        "Apakah anda yakin menukar produk ini?",
        onTap: () {
          Navigator.pop(confirmDialogContext, true);
        },
      ),
    );

    if (confirmed != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (loadingContext) => const LoadingWidget(height: 100),
    );

    final userProvider = context.read<UserProvider>();
    final rewardProvider = context.read<RewardProvider>();
    final success = await rewardProvider.rewardExchange(
      quantity,
      reward.id,
      reward.unitPoint * quantity,
      userProvider,
    );

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (success) {
      showSuccessTopSnackBar(
        context,
        "Penukaran Sedang Diproses",
        icon: const Icon(Icons.shopping_bag),
      );
      Navigator.pop(context);
    } else {
      showErrorTopSnackBar(
        context,
        rewardProvider.message,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RewardProvider>().getRewards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              await context.read<RewardProvider>().getRewards(forceRefresh: true);
            },
            color: Colors.black,
            backgroundColor: const Color(0xFF55C173),
            child: CustomScrollView(
              key: PageStorageKey('reward_scroll'),
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

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GiftSearchBar(
                      onSearch: (query) {
                        setState(() {
                          _query = query;
                        });
                      },
                    ),
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

                Consumer<RewardProvider>(
                  builder: (context, provider, _) {
                    final rewards = provider.rewards;

                    final filtered = _query.isEmpty
                        ? rewards
                        : rewards
                        .where(
                          (q) => q.rewardName.toLowerCase().contains(
                            _query.toLowerCase(),
                          ),
                        )
                        .toList();

                    if (provider.isLoading) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: LoadingWidget()),
                      );
                    }

                    if (provider.rewards.isEmpty) {
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
                        final reward = filtered[index];

                        return GiftCard(
                          reward: reward,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GiftExchangeScreen(
                                  reward: reward,
                                  onPressed: (quantity) => _showConfirmDialog(context, quantity, reward),
                                ),
                              ),
                            ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
