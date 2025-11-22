import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/login_required_dialog.dart';
import 'package:ecozyne_mobile/data/models/reward.dart';
import 'package:ecozyne_mobile/data/providers/reward_provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GiftCard extends StatelessWidget {
  final Reward reward;
  final VoidCallback onPressed;

  const GiftCard({
    super.key,
    required this.reward,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: reward.photo,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 400),
              placeholder: (context, url) => Container(
                height: 150,
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 150,
                color: Colors.grey.shade100,
                child: const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomText(
              reward.rewardName,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              maxLines: 3,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomText(
                    "${reward.unitPoint} Poin",
                    fontSize: 14,
                    color: const Color(0xFF55C173),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ElevatedButton(
                  onPressed: reward.stock > 0
                      ? () {
                    final userProvider = context.read<UserProvider>();
                    if (userProvider.isGuest || userProvider.user == null) {
                      showDialog(
                        context: context,
                        builder: (context) => const LoginRequiredDialog(),
                      );
                    } else {
                      onPressed();
                    }
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF55C173),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                  ),
                  child: CustomText(
                    reward.stock > 0 ?
                    'Tukar poin'
                    :'Stok Habis',
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
