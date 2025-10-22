import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/waste_deposit/widgets/accepted_waste_delivery_tab.dart';
import 'package:ecozyne_mobile/features/waste_deposit/widgets/waste_delivery_tab.dart';
import 'package:flutter/material.dart';

class WasteDepositScreen extends StatefulWidget {
  const WasteDepositScreen({super.key});

  @override
  State<WasteDepositScreen> createState() => _WasteDepositScreenState();
}

class _WasteDepositScreenState extends State<WasteDepositScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      if (_tabController.index == 0) {
        print('Panggil API untuk tab Saat Ini');
      } else if (_tabController.index == 1) {
        print('Panggil API untuk tab Terima');
      }
    });

    print('Panggil API pertama kali untuk tab Saat Ini');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText(
          'Setoran Sampah',
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: 'Saat ini'),
            Tab(text: 'Terima'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          WasteDeliveryTab(),
          AcceptedWasteDeliveryTab(),
        ],
      ),
    );
  }
}
