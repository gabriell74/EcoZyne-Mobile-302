import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TrackingCard extends StatelessWidget {
  final Map<String, dynamic> enzyme;
  final double progress;

  const TrackingCard({
    super.key,
    required this.enzyme,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: CustomText(
          enzyme['name'],
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              "Mulai: ${DateFormatter.formatDate(enzyme['startDate'])}",
            ),
            Text(
              "Selesai: ${DateFormatter.formatDate(enzyme['dueDate'])}",
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: progress >= 1
                  ? Colors.green
                  : Colors.orangeAccent,
            ),
            const SizedBox(height: 6),
            CustomText(
              progress >= 1
                  ? "Selesai"
                  : "Progress ${(progress * 100).toStringAsFixed(0)}%",
              color: progress >= 1
                  ? Colors.green
                  : Colors.orange[700],
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
