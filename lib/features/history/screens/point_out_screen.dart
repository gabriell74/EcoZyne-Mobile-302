import 'package:ecozyne_mobile/features/order/screens/order_accepted_tab.dart';
import 'package:ecozyne_mobile/features/order/screens/order_current_tab.dart';
import 'package:ecozyne_mobile/features/order/screens/order_rejected_tab.dart';
import 'package:flutter/material.dart';

class PointOutScreen extends StatefulWidget {
  const PointOutScreen({super.key});

  @override
  State<PointOutScreen> createState() => OrderScreenState();
}

class OrderScreenState extends State<PointOutScreen>
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
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(text: 'Saat Ini'),
                  Tab(text: 'Terima'),
                  Tab(text: 'Tolak'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OrderCurrentTab(),
          OrderAcceptedTab(),
          OrderRejectedTab(),
        ],
      ),
    );
  }
}
