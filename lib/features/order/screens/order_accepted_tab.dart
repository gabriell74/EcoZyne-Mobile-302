import 'package:ecozyne_mobile/features/order/widgets/order_card.dart';
import 'package:flutter/material.dart';
 
class OrderAcceptedTab extends StatelessWidget {
  const OrderAcceptedTab({super.key});

  final List<Map<String, dynamic>> acceptedOrders = const [
    {'produk': 'Pupuk', 'jumlah': 12, 'metode': 'COD'},
    {'produk': 'Pupuk', 'jumlah': 8, 'metode': 'COD'},
    {'produk': 'Pupuk', 'jumlah': 20, 'metode': 'COD'},
  ];

  @override
  Widget build(BuildContext context) {
    if (acceptedOrders.isEmpty) {
      return const Center(child: Text('Belum ada pesanan diterima'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: acceptedOrders.length,
      itemBuilder: (context, index) {
        final item = acceptedOrders[index];
        return OrderCard(
          produk: item['produk'],
          jumlah: item['jumlah'],
          metode: item['metode'],
          showButtons: false,
        );
      },
    );
  }
}
