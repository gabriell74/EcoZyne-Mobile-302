import 'package:ecozyne_mobile/features/order/widgets/order_card.dart';
import 'package:flutter/material.dart';

class OrderRejectedTab extends StatelessWidget {
  const OrderRejectedTab({super.key});

  final List<Map<String, dynamic>> rejectedOrders = const [
    {'produk': 'Pupuk', 'jumlah': 50, 'metode': 'COD'},
    {'produk': 'Pupuk', 'jumlah': 70, 'metode': 'COD'},
    {'produk': 'Pupuk', 'jumlah': 100, 'metode': 'COD'},
  ];

  @override
  Widget build(BuildContext context) {
    if (rejectedOrders.isEmpty) {
      return const Center(child: Text('Belum ada pesanan ditolak'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rejectedOrders.length,
      itemBuilder: (context, index) {
        final item = rejectedOrders[index];
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
