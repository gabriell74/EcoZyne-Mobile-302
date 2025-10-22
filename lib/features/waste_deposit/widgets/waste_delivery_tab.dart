import 'package:flutter/material.dart';

import 'waste_delivery_card.dart';

class WasteDeliveryTab extends StatelessWidget {
  const WasteDeliveryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return const WasteDeliveryCard();
      },
    );
  }
}