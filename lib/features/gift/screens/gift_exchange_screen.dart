import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/build_image_section.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/login_required_dialog.dart';
import 'package:ecozyne_mobile/data/models/reward.dart';
import 'package:ecozyne_mobile/data/providers/reward_provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/marketplace/widgets/feature_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GiftExchangeScreen extends StatefulWidget {
  final Reward reward;
  final Future<void> Function(int quantity) onPressed;

  const GiftExchangeScreen({
    super.key,
    required this.reward,
    required this.onPressed,
  });

  @override
  State<GiftExchangeScreen> createState() => _GiftExchangeScreenState();
}

class _GiftExchangeScreenState extends State<GiftExchangeScreen> {
  int _quantity = 1;

  void increment(int stock) {
    if (_quantity < stock) setState(() => _quantity++);
  }

  void decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RewardProvider>().updateRewardStock(widget.reward.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reward = widget.reward;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildImageSection(
                    id: reward.id,
                    photo: reward.photo,
                    tagPrefix: 'reward',
                  ),

                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              "${reward.unitPoint} Poin",
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                            Selector<RewardProvider, int>(
                              selector: (_, provider) {
                                final updatedReward = provider.rewards.firstWhere(
                                      (r) => r.id == reward.id,
                                  orElse: () => reward,
                                );
                                return updatedReward.stock;
                              },
                              builder: (_, stock, __) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: stock > 0
                                      ? const Color(0xFF55C173)
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CustomText(
                                  "Stok: ${stock.toString()}",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        CustomText(
                          reward.rewardName,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),

                        const SizedBox(height: 24),

                        FeatureCard(
                          icon: Icons.card_giftcard,
                          title: "Hadiah Poin",
                          subtitle: "Tukarkan poin Anda dengan hadiah menarik",
                          color: const Color(0xFF55C173),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF55C173).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.shopping_basket_outlined,
                                  color: Color(0xFF55C173),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText(
                                      "Jumlah",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      "Pilih jumlah hadiah",
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: decrement,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.remove, size: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: CustomText(
                                      "$_quantity",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final stock = context
                                          .read<RewardProvider>()
                                          .rewards
                                          .firstWhere(
                                            (r) => r.id == reward.id,
                                        orElse: () => reward,
                                      )
                                          .stock;
                                      increment(stock);
                                    },
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF55C173),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        const CustomText(
                          "Total Poin",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),

                        const SizedBox(height: 12),

                        Selector<RewardProvider, int>(
                          selector: (_, provider) {
                            final stock = provider.rewards.firstWhere(
                                  (r) => r.id == reward.id,
                              orElse: () => reward,
                            ).stock;
                            return stock;
                          },
                          builder: (_, stock, __) => Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      "Total ($_quantity item)",
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      "${reward.unitPoint} × $_quantity",
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ],
                                ),
                                CustomText(
                                  "${reward.unitPoint * _quantity} Poin",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF55C173),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              child: Material(
                color: Colors.black12.withValues(alpha: 0.5),
                shape: const CircleBorder(),
                elevation: 4,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: Selector<RewardProvider, int>(
                              selector: (_, provider) {
                                final stock = provider.rewards.firstWhere(
                                      (r) => r.id == reward.id,
                                  orElse: () => reward,
                                ).stock;
                                return stock;
                              },
                              builder: (_, stock, __) => ElevatedButton(
                                onPressed: stock > 0
                                    ? () {
                                  final userProvider =
                                  context.read<UserProvider>();
                                  if (userProvider.isGuest ||
                                      userProvider.user == null) {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                      const LoginRequiredDialog(),
                                    );
                                  } else {
                                    widget.onPressed(_quantity);
                                  }
                                }
                                    : null,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      stock > 0
                                          ? Icons.card_giftcard_outlined
                                          : Icons.error_outline,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    CustomText(
                                      stock > 0 ? "Tukar Hadiah" : "Stok Habis",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}