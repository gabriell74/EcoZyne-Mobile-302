import 'package:ecozyne_mobile/core/utils/history_helper.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/history/screens/order_detail_screen.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final dynamic order;

  const OrderCard({super.key, required this.order});

  Color _statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "processed":
        return Colors.blue;
      case "delivered":
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
      case "processed":
        return "Diproses";
      case "delivered":
        return "Selesai";
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
      case "processed":
        return Icons.local_shipping_rounded;
      case "delivered":
        return Icons.check_circle_rounded;
      case "cancelled":
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trx = order.productTransactions.first;
    final statusColor = _statusColor(order.statusOrder);

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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: order),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shopping_bag_rounded,
                    color: Colors.pink, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: CustomText("Pembelian Produk",
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: statusColor.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_statusIcon(order.statusOrder),
                                  size: 14, color: statusColor),
                              const SizedBox(width: 4),
                              CustomText(_statusText(order.statusOrder),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    CustomText(
                      trx.productName,
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 12, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        CustomText(timeAgo(order.createdAt),
                            color: Colors.grey.shade600, fontSize: 12),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.grey.shade400, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}