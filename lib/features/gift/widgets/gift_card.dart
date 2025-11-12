import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/login_required_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GiftCard extends StatelessWidget {
  final Map<String, String> item;

  const GiftCard({super.key, required this.item});

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        "Apakah anda yakin menukar produk ini?",
        onTap: () {
          Navigator.pop(context);
          showSuccessTopSnackBar(
            context,
            "Penukaran Sedang Diproses",
            icon: const Icon(Icons.shopping_bag),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              item["image"]!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomText(
                item["name"]!,
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
                      item["poin"]!,
                      fontSize: 16,
                      color: const Color(0xFF55C173),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final userProvider = context.read<UserProvider>();

                      if (userProvider.isGuest || userProvider.user == null) {
                        showDialog(
                          context: context,
                          builder: (context) => const LoginRequiredDialog(),
                        );
                      } else {
                        _showConfirmDialog(context);
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF55C173),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                    ),
                    child: const CustomText(
                      'Tukar poin',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
