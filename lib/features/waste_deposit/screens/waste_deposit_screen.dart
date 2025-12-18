import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/providers/trash_transaction_provider.dart';
import 'package:ecozyne_mobile/features/waste_deposit/widgets/accepted_waste_delivery_tab.dart';
import 'package:ecozyne_mobile/features/waste_deposit/widgets/rejected_waste_delivery_tab.dart';
import 'package:ecozyne_mobile/features/waste_deposit/widgets/waste_delivery_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrashTransactionProvider>().getTrashTransactions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Setoran Sampah", fontWeight: FontWeight.bold, fontSize: 18),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: 'Saat ini'),
            Tab(text: 'Terima'),
            Tab(text: 'Tolak'),
          ],
        ),
      ),
      body: AppBackground(
        child: TabBarView(
          controller: _tabController,
          children: const [
            WasteDeliveryTab(),
            AcceptedWasteDeliveryTab(),
            RejectedWasteDeliveryTab(),
          ],
        ),
      ),
    );
  }
}
