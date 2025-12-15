import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/history/screens/order_history_screen.dart';
import 'package:ecozyne_mobile/features/history/screens/point_in_screen.dart';
import 'package:ecozyne_mobile/features/history/screens/point_out_screen.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: const Duration(milliseconds: 180),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Riwayat", fontWeight: FontWeight.bold, fontSize: 18),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: 'Poin Masuk'),
            Tab(text: 'Poin Keluar'),
            Tab(text: 'Pembelian'),
          ],
        ),
      ),
      body: AppBackground(
        child: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: const [
            PointInScreen(),
            PointOutScreen(),
            OrderHistoryScreen(),
          ],
        ),
      ),
    );
  }
}