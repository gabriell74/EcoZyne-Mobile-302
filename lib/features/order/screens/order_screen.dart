import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'order_current_tab.dart';
import 'order_accepted_tab.dart';
import 'order_rejected_tab.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Pesanan', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xFF55C173),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[100],
          tabs: const [
            Tab(text: 'Saat Ini'),
            Tab(text: 'Terima'),
            Tab(text: 'Tolak'),
          ],
        ),
      ),
      body: AppBackground(
        child: TabBarView(
          controller: _tabController,
          children: const [
            OrderCurrentTab(),
            OrderAcceptedTab(),
            OrderRejectedTab(),
          ],
        ),
      ),
    );
  }
}
