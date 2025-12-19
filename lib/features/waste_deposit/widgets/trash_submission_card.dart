import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/trash_transaction.dart';
import 'package:flutter/material.dart';

class TrashSubmissionsCard extends StatelessWidget {
  final TrashTransaction submission;
  final Future<void> Function()? onAccepted;
  final VoidCallback? onRejected;
  final VoidCallback? onCompleted;
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

  void _showCompletedDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const CustomText(
                "Detail Pengantaran Sampah",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),

              const SizedBox(height: 16),

              if (submission.trashImage != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    submission.trashImage!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              Row(
                children: [
                  const Icon(Icons.scale_rounded),
                  const SizedBox(width: 8),
                  CustomText(
                    "Berat Sampah: ${submission.trashWeight} kg",
                    fontSize: 14,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber),
                  const SizedBox(width: 8),
                  CustomText(
                    "Poin Diperoleh: ${submission.pointEarned}",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
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
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
              label: const CustomText("Tolak", color: Colors.red),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () async => onAccepted?.call(),
              icon: const Icon(Icons.check_circle_outline),
              label: const CustomText("Terima"),
            ),
          ],
          if (showCompleteButton) ...[
            ElevatedButton.icon(
              onPressed: onCompleted,
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

  Widget _buildCompletedHint() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF55C173).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF55C173).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: const Color(0xFF55C173),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText(
              "Ketuk untuk melihat detail penyetoran",
              fontSize: 12,
              color: const Color(0xFF55C173),
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: const Color(0xFF55C173),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = submission.status;

    return InkWell(
      onTap: status == 'completed'
          ? () => _showCompletedDetail(context)
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
                    text: _statusText(status),
                    color: _statusColor(status),
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
                      color: const Color(0xFF55C173)
                          .withValues(alpha: 0.15),
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
                            const Icon(Icons.phone, size: 13),
                            const SizedBox(width: 8),
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

              _buildActionButtons(),

              if (status == 'completed') _buildCompletedHint(),
            ],
          ),
        ),
      ),
    );
  }
}