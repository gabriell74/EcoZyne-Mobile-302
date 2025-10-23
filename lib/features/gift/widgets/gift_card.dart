import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:flutter/material.dart';

class GiftCard extends StatelessWidget {
  final Map<String, String> item;

  const GiftCard({super.key, required this.item});

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
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(item["image"]!),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomText(
                item["name"]!,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                maxLines: 2,
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF55C173),
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Tukar poin'),
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
