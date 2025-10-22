import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class AcceptedWasteDeliveryTab extends StatelessWidget {
  const AcceptedWasteDeliveryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (context, index) => const Divider(height: 20),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CustomText(
                    'Nama Pengguna',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  SizedBox(height: 4),
                  CustomText(
                    '10 kg, sisa sayur dan kulit buah',
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ],
              ),
            ),

            const CustomText(
              '100 poin',
              fontWeight: FontWeight.bold, fontSize: 14
            ),
          ],
        );
      },
    );
  }
}
