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
            // Bagian hijau untuk judul dan tombol back
            Container(
              color: Colors.green,
              padding: const EdgeInsets.only(
                top: 40,
                left: 8,
                right: 16,
                bottom: 16,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Pesanan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // biar teks tetap center
                ],
              ),
            ),

            // Bagian TabBar putih
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
