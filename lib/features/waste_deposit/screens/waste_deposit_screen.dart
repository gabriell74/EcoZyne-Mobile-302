import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/waste_deposit/widgets/accepted_waste_delivery_tab.dart';
import 'package:ecozyne_mobile/features/waste_deposit/widgets/waste_delivery_tab.dart';
import 'package:flutter/material.dart';

class WasteDepositScreen extends StatefulWidget {
  final List<Map<String, dynamic>> _wasteDeposit = [
    {
      "username": "green123",
      "name": "Andi Wijaya",
      "email": "andi.wijaya@example.com"
    },
    {
      "username": "eco_lover",
      "name": "Sari Putri",
      "email": "sari.putri@example.com"
    },
    {
      "username": "recycle_master",
      "name": "Budi Santoso",
      "email": "budi.santoso@example.com"
    },
    {
      "username": "wastewatcher",
      "name": "Rina Dewi",
      "email": "rina.dewi@example.com"
    },
  ];

  final List<Map<String, dynamic>> _acceptedWaste = [
    {
      "username": "green123",
      "weight": "5 kg",
      "description": "Sisa sayur dan kulit buah",
      "point": "50 poin"
    },
    {
      "username": "eco_lover",
      "weight": "8 kg",
      "description": "Kertas bekas dan kardus",
      "point": "80 poin"
    },
    {
      "username": "recycle_master",
      "weight": "12 kg",
      "description": "Botol plastik dan kaleng",
      "point": "120 poin"
    },
    {
      "username": "wastewatcher",
      "weight": "7 kg",
      "description": "Sisa makanan dan daun kering",
      "point": "70 poin"
    },
  ];


  WasteDepositScreen({super.key});

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
        children: [
          WasteDeliveryTab(wasteDeposit: widget._wasteDeposit),
          AcceptedWasteDeliveryTab(acceptedWaste: widget._acceptedWaste,),
        ],
      ),
    );
  }
}
