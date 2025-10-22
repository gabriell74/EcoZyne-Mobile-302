import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/waste_deposit/widgets/accepted_waste_delivery_tab.dart';
import 'package:ecozyne_mobile/features/waste_deposit/widgets/waste_delivery_tab.dart';
import 'package:flutter/material.dart';

class WasteDepositScreen extends StatelessWidget {
  const WasteDepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: const Color(0xFF55C173),
          title: const CustomText(
            'Setoran Sampah',
            fontWeight: FontWeight.bold
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Saat ini'),
              Tab(text: 'Terima'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WasteDeliveryTab(),

            AcceptedWasteDeliveryTab(),
          ],
        ),
      ),
    );
  }
}
