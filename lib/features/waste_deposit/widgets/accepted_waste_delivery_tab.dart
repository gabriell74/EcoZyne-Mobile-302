import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class AcceptedWasteDeliveryTab extends StatelessWidget {
  final List<Map<String, dynamic>> acceptedWaste;

  const AcceptedWasteDeliveryTab({super.key, required this.acceptedWaste});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: acceptedWaste.length,
      separatorBuilder: (context, index) => const Divider(height: 20),
      itemBuilder: (context, index) {
        final data = acceptedWaste[index];
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
                children: [
                  CustomText(
                    data['username'],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    '${data['weight']}, ${data['description']}',
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ],
              ),
            ),
            CustomText(
              data['point'],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ],
        );
      },
    );
  }
}