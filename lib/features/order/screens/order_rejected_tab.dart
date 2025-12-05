import 'package:ecozyne_mobile/features/order/widgets/order_card.dart';
import 'package:flutter/material.dart';

class OrderRejectedTab extends StatelessWidget {
  const OrderRejectedTab({super.key});

  final List<Map<String, dynamic>> rejectedOrders = const [
    {
      'tanggal': 'June 14, 2023',
      'produk': 'Eco Enzyme',
      'jumlah': 1,
      'metode': 'COD',
      'bankSampah': 'Waste Bank Maju',
      'status': 'Ditolak',
      'reason': 'Stok produk tidak tersedia di bank sampah.', // Alasan Penolakan
    },
    {
      'tanggal': 'May 22, 2023',
      'produk': 'Pupuk Kompos',
      'jumlah': 2,
      'metode': 'COD',
      'bankSampah': 'Waste Bank Sejahtera',
      'status': 'Dibatalkan',
      'reason': 'Permintaan pembatalan dari penjual.', // Alasan Pembatalan
    },
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
          tanggal: item['tanggal'],
          produk: item['produk'],
          jumlah: item['jumlah'],
          metode: item['metode'],
          bankSampah: item['bankSampah'],
          showButtons: false,
          status: item['status'],
          reason: item['reason'],
        );
      },
    );
  }
}