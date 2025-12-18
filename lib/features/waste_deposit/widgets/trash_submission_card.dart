import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/trash_transaction.dart';
import 'package:flutter/material.dart';

class TrashSubmissionsCard extends StatelessWidget {
  final TrashTransaction submission;
  final Future<void> Function()? onAccepted;
  final VoidCallback? onRejected;
  final Future<void> Function()? onCompleted;
  final bool showActionButtons;
  final bool showCompleteButton;

  const TrashSubmissionsCard({
    super.key,
    required this.submission,
    this.onAccepted,
    this.onRejected,
    this.onCompleted,
    this.showCompleteButton = false,
    this.showActionButtons = false,
  });

  String _statusText(String status) {
    switch (status) {
      case "pending":
        return "Menunggu";
      case "approved":
        return "Disetujui";
      case "rejected":
        return "Ditolak";
      case "completed":
        return "Sampah Disetorkan";
      default:
        return "Unknown";
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "approved":
        return Colors.blue;
      case "completed":
        return const Color(0xFF55C173);
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case "pending":
        return Icons.access_time_rounded;
      case "approved":
        return Icons.check_circle_rounded;
      case "completed":
        return Icons.task_alt_rounded;
      case "rejected":
        return Icons.cancel_rounded;
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
              onPressed: onRejected,
              icon: const Icon(Icons.cancel_outlined, color: Colors.red,),
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
              icon: const Icon(Icons.upload),
              label: const CustomText("Setor sampah"),
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
    final status = submission.status;
    final statusText = _statusText(status);
    final statusColor = _statusColor(status);

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
                  DateFormatter.formatDate(submission.createdAt),
                  fontWeight: FontWeight.bold,
                ),
                _statusBadge(
                  text: statusText,
                  color: statusColor,
                  icon: _statusIcon(status),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF55C173).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xFF55C173),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "${submission.communityName} (${submission.username})",
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 13,),
                          const SizedBox(width: 8,),
                          CustomText(
                            submission.phoneNumber.toString(),
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (submission.pointEarned != null &&
                submission.trashWeight != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'Detail Sampah',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    const SizedBox(height: 6),
                    if (submission.trashWeight != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.scale_rounded,
                              size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 6),
                          CustomText(
                            'Berat: ${submission.trashWeight} kg',
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            if (status == 'rejected') ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_rounded,
                        size: 16, color: Colors.red.shade700),
                    const SizedBox(width: 6),
                    Expanded(
                      child: CustomText(
                        'Alasan Penolakan: ${submission.rejectionReason}',
                        fontSize: 12,
                        color: Colors.red.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            _buildActionButtons(),
          ],
        ),
      ),
    );
  }
}