import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/eco_enzyme_tracking.dart';
import 'package:flutter/material.dart';

class TrackingCard extends StatelessWidget {
  final EcoEnzymeTracking enzyme;
  final double progress;
  final VoidCallback onDelete;

  const TrackingCard({
    super.key,
    required this.enzyme,
    required this.progress,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = progress >= 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomText(
                    enzyme.batchName,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomText(
                    isCompleted ? "Selesai" : "Berjalan",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                    isCompleted ? Colors.green : Colors.orange[800],
                  ),
                ),

                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  tooltip: 'Hapus tracking',
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "Mulai: ${DateFormatter.formatDate(enzyme.startDate)}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.event_available,
                    size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "Selesai: ${DateFormatter.formatDate(enzyme.dueDate)}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 14),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                color:
                isCompleted ? Colors.green : Colors.orangeAccent,
              ),
            ),

            const SizedBox(height: 8),

            CustomText(
              isCompleted
                  ? "Progress 100%"
                  : "Progress ${(progress * 100).toStringAsFixed(0)}%",
              fontWeight: FontWeight.w600,
              color:
              isCompleted ? Colors.green : Colors.orange[700],
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.sticky_note_2_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      enzyme.notes,
                      style: const TextStyle(
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
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
