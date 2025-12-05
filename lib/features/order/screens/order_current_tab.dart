import 'package:ecozyne_mobile/features/order/widgets/order_card.dart';
import 'package:flutter/material.dart';

class OrderCurrentTab extends StatelessWidget {
  const OrderCurrentTab({super.key});

  final List<Map<String, dynamic>> pesananList = const [
    {
      'tanggal': 'May 22, 2023',
      'produk': 'Pupuk Eco Enzyme',
      'jumlah': 12,
      'metode': 'COD (Bayar di Tempat)',
      'bankSampah': 'Bank Sampah Melati',
      'namaKurir': 'Budi Santoso',
      'status': 'Menunggu',
      'reason': null, // Tidak ada alasan
    },
    {
      'tanggal': 'June 14, 2023',
      'produk': 'Botol Daur Ulang',
      'jumlah': 3,
      'metode': 'COD (Bayar di Tempat)',
      'bankSampah': 'TPS 3R Mulyoagung',
      'namaKurir': 'Agus Setiawan',
      'status': 'Dalam Pengiriman',
      'reason': null, // Tidak ada alasan
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (pesananList.isEmpty) {
      return const Center(child: Text('Belum ada pesanan saat ini'));
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
          bankSampah: item['bankSampah'],
          showButtons: true, // Tombol Batalkan Pesanan aktif
          status: item['status'],
          reason: item['reason'],
        );
      },
    );
  }
}