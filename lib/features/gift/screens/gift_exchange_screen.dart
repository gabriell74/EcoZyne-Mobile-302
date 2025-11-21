import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/login_required_dialog.dart';
import 'package:ecozyne_mobile/data/providers/reward_provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GiftExchangeScreen extends StatefulWidget {
  final int rewardId;
  final VoidCallback onPressed;

  const GiftExchangeScreen({
    super.key,
    required this.rewardId,
    required this.onPressed,
  });

  @override
  State<GiftExchangeScreen> createState() => _GiftExchangeScreenState();
}

class _GiftExchangeScreenState extends State<GiftExchangeScreen> {
  int _quantity = 1;

  void increment(int stock) {
    if (_quantity < stock) {
      setState(() => _quantity++);
    }
  }

  void decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RewardProvider>().getRewardById(widget.rewardId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Detail Produk", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: Consumer<RewardProvider>(
        builder: (context, rewardProvider, _) {
          final reward = rewardProvider.rewardDetail;

          if (rewardProvider.isLoading) {
            return const Center(child: LoadingWidget(width: 120));
          }

          if (reward == null) {
            return Center(
              child: CustomText(
                rewardProvider.message,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Hero(
                          tag: 'reward-tag-${widget.rewardId}',
                          child: CachedNetworkImage(
                            imageUrl: reward.photo,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: LoadingWidget(width: 100),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 280,
                              color: Colors.grey.shade100,
                              child: const Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.grey, size: 50),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  "${reward.unitPoint} Poin",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink,
                                ),
                                CustomText(
                                  "Stok: ${reward.stock}",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            CustomText(
                              reward.rewardName,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB2E8C9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.card_giftcard,
                                    color: Colors.white, size: 30),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      reward.rewardName,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      "Stok: ${reward.stock}",
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      "${reward.unitPoint} Point",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF55C173),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: decrement,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(6),
                                        child: Icon(Icons.remove, size: 18),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                    child: CustomText(
                                      "$_quantity",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => increment(reward.stock),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(6),
                                        child: Icon(Icons.add, size: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "Total ($_quantity item)",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              CustomText(
                                "${reward.unitPoint * _quantity} Point",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: const Color(0xFF55C173),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),

              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final userProvider = context.read<UserProvider>();

                        if (userProvider.isGuest || userProvider.user == null) {
                          showDialog(
                            context: context,
                            builder: (context) => const LoginRequiredDialog(),
                          );
                        } else {
                          widget.onPressed();
                        }
                      },
                      child: const CustomText(
                        "Tukar Hadiah",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
