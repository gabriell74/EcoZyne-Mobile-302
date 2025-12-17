import 'package:ecozyne_mobile/core/utils/history_helper.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class WasteBankExchangeHistoryScreen extends StatelessWidget {
  const WasteBankExchangeHistoryScreen({super.key});

  // contoh dummy data (nanti ganti dari API / provider)
  List<dynamic> get exchanges => [
        {
          "status": "pending",
          "wasteBankName": "Bank Sampah Sejahtera",
          "createdAt": DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          "status": "approved",
          "wasteBankName": "Bank Sampah Hijau",
          "createdAt": DateTime.now().subtract(const Duration(days: 3)),
        },
        {
          "status": "cancelled",
          "wasteBankName": "Bank Sampah Bersih",
          "createdAt": DateTime.now().subtract(const Duration(days: 5)),
        },
      ];

  Color _statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "approved":
        return const Color(0xFF55C173);
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusText(String status) {
    switch (status) {
      case "pending":
        return "Menunggu";
      case "approved":
        return "Disetujui";
      case "cancelled":
        return "Dibatalkan";
      default:
        return "Unknown";
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case "pending":
        return Icons.access_time_rounded;
      case "approved":
        return Icons.check_circle_rounded;
      case "cancelled":
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Tukar Sampah'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exchanges.length,
        itemBuilder: (context, index) {
          final exchange = exchanges[index];

          return _exchangeStatusCard(context, exchange);
        },
      ),
    );
  }

  // CARD (dipindah jadi method, bukan screen)
  Widget _exchangeStatusCard(BuildContext context, dynamic exchange) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.recycling_rounded,
                color: Color(0xFF55C173),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: CustomText(
                          "Pengajuan Tukar Sampah",
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _statusColor(exchange["status"])
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _statusColor(exchange["status"])
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _statusIcon(exchange["status"]),
                              size: 14,
                              color: _statusColor(exchange["status"]),
                            ),
                            const SizedBox(width: 4),
                            CustomText(
                              _statusText(exchange["status"]),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _statusColor(exchange["status"]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  CustomText(
                    exchange["wasteBankName"],
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 12, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      CustomText(
                        timeAgo(exchange["createdAt"]),
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
