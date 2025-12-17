import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/utils/price_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/waste_bank_order.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final WasteBankOrder order;

  final bool showActionButtons;
  final bool showCompleteButton;

  final Future<void> Function()? onAccepted;
  final Future<void> Function()? onRejected;
  final Future<void> Function()? onCompleted;

  const OrderCard({
    super.key,
    required this.order,
    this.showActionButtons = false,
    this.showCompleteButton = false,
    this.onAccepted,
    this.onRejected,
    this.onCompleted,
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
      case "rejected":
        return Colors.redAccent;
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

  String _paymentStatusText(String status) {
    switch (status) {
      case "pending":
        return "Belum Bayar";
      case "paid":
        return "Sudah Bayar";
      case "failed":
        return "Gagal";
      default:
        return "Unknown";
    }
  }

  Color _paymentStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "paid":
        return const Color(0xFF55C173);
      case "failed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _paymentStatusIcon(String status) {
    switch (status) {
      case "pending":
        return Icons.payments_outlined;
      case "paid":
        return Icons.check_circle_rounded;
      case "failed":
        return Icons.error_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Widget _statusBadge({
    required String text,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          CustomText(
            text,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (!showActionButtons && !showCompleteButton) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showActionButtons) ...[
            OutlinedButton.icon(
              onPressed: () async {
                await onRejected?.call();
              },
              icon: const Icon(Icons.cancel_outlined),
              label: const CustomText("Tolak", color: Colors.red),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () async {
                await onAccepted?.call();
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const CustomText("Terima"),
            ),
          ],

          if (showCompleteButton) ...[
            ElevatedButton.icon(
              onPressed: () async {
                await onCompleted?.call();
              },
              icon: const Icon(Icons.task_alt_rounded),
              label: const CustomText("Tandai Selesai"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF55C173),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderStatusText = _orderStatusText(order.statusOrder);
    final orderStatusColor = _orderStatusColor(order.statusOrder);

    final paymentStatusText = _paymentStatusText(order.statusPayment);
    final paymentStatusColor = _paymentStatusColor(order.statusPayment);

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
                Row(
                  children: [
                    _statusBadge(
                      text: orderStatusText,
                      color: orderStatusColor,
                      icon: _orderStatusIcon(order.statusOrder),
                    ),
                    const SizedBox(width: 6),
                    _statusBadge(
                      text: paymentStatusText,
                      color: paymentStatusColor,
                      icon: _paymentStatusIcon(order.statusPayment),
                    ),
                  ],
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
                  child: const Icon(
                    Icons.shopping_bag_rounded,
                    color: Colors.pink,
                  ),
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

            _buildActionButtons(),
          ],
        ),
      ),
    );
  }
}
