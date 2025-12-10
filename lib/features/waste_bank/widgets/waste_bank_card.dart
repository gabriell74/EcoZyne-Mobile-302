import 'package:ecozyne_mobile/data/models/waste_bank_submission.dart';
import 'package:ecozyne_mobile/features/waste_bank/screens/waste_bank_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';

class WasteBankCard extends StatelessWidget {
  final WasteBankSubmission wasteBank;
  const WasteBankCard({super.key, required this.wasteBank});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WasteBankDetailScreen(wasteBank: wasteBank),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 120,
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/cover3.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Bank Sampah Melati",
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          "Batam Kota",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          "Buka Senin - Jumat",
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
