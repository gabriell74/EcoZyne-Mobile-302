import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String tanggal;
  final String produk;
  final int jumlah;
  final String metode;
  final String bankSampah;
  final bool showButtons;
  final String status;
  final String? reason;

  const OrderCard({
    super.key,
    required this.tanggal,
    required this.produk,
    required this.jumlah,
    required this.metode,
    required this.bankSampah,
    required this.showButtons,
    required this.status,
    this.reason,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Dalam Pengiriman':
        return Colors.blue;
      case 'Selesai':
        return Colors.green;
      case 'Ditolak':
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  tanggal,
                  fontWeight: FontWeight.bold, color: Colors.black87,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomText(
                    status,
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        '$produk',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        '$jumlah Item | $metode',
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        'Pembeli: $bankSampah',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (reason != null && reason!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: CustomText(
                'Alasan: $reason',
                color: Colors.red.shade700, fontStyle: FontStyle.italic,
              ),
            ),
          
          if (showButtons)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.cancel_outlined, color: Colors.black),
                    label: const Text('Tolak Pesanan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.check_circle_outline, color: Colors.black),
                    label: const Text('Terima Pesanan'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}