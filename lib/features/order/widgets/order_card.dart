import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/utils/price_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/waste_bank_order.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final WasteBankOrder order;
  final bool showButtons;

  const OrderCard({
    super.key,
    required this.order,
    this.showButtons = false,
  });

  String _orderStatusText(String status) {
    switch (status) {
      case "pending":
        return "Menunggu";
      case "processed":
        return "Diproses";
      case "delivered":
        return "Selesai";
      case "cancelled":
        return "Dibatalkan";
      case "rejected":
        return "Ditolak";
      default:
        return "Unknown";
    }
  }

  Color _orderStatusColor(String status) {
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

  IconData _orderStatusIcon(String status) {
    switch (status) {
      case "pending":
        return Icons.access_time_rounded;
      case "processed":
        return Icons.local_shipping_rounded;
      case "delivered":
        return Icons.check_circle_rounded;
      case "rejected":
        return Icons.block_rounded;
      case "cancelled":
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusText = _orderStatusText(order.statusOrder);
    final statusColor = _orderStatusColor(order.statusOrder);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  DateFormatter.formatDate(order.createdAt),
                  fontWeight: FontWeight.bold,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _orderStatusIcon(order.statusOrder),
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        statusText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.pink.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shopping_bag_rounded,
                      color: Colors.pink),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        order.productName,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        "${order.amount} item",
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(height: 6),
                      CustomText(
                        order.totalPrice.toString().toCurrency,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            CustomText(
              "Pembeli: ${order.customerName}",
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 4),
            CustomText(
              order.phoneNumber,
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
            const SizedBox(height: 4),
            CustomText(
              order.address,
              fontSize: 13,
              color: Colors.grey.shade700,
            ),

            if (order.cancellationReason != null &&
                order.cancellationReason!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: CustomText(
                  "Alasan: ${order.cancellationReason}",
                  color: Colors.red.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),

            if (showButtons) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.cancel_outlined),
                    label: const CustomText("Tolak", color: Colors.red),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check_circle_outline),
                    label: const CustomText("Terima"),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}