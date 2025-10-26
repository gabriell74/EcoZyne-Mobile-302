import 'package:ecozyne_mobile/features/order/widgets/order_card.dart';
import 'package:flutter/material.dart';

class OrderCurrentTab extends StatelessWidget {
  const OrderCurrentTab({super.key});

  final List<Map<String, dynamic>> pesananList = const [
    {
      'tanggal': 'May 22, 2023',
      'produk': 'Pupuk',
      'jumlah': 12,
      'metode': 'COD',
    },
    {
      'tanggal': 'June 14, 2023',
      'produk': 'Pupuk',
      'jumlah': 3,
      'metode': 'COD',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (pesananList.isEmpty) {
      return const Center(child: Text('Belum ada pesanan'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pesananList.length,
      itemBuilder: (context, index) {
        final item = pesananList[index];
        return OrderCard(
          tanggal: item['tanggal'],
          produk: item['produk'],
          jumlah: item['jumlah'],
          metode: item['metode'],
          showButtons: true,
        );
      },
    );
  }
}
