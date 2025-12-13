import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Color subtitleColor;
  final String? description;
  final String? time;

  const HistoryItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.subtitleColor = Colors.black,
    this.description,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                const SizedBox(height: 4),
                CustomText(
                  subtitle,
                  color: subtitleColor.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  CustomText(
                    description!,
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ],
              ],
            ),
          ),
          if (time != null) ...[
            const SizedBox(width: 10),
            Column(
              children: [
                Icon(Icons.access_time_rounded, size: 12, color: Colors.grey.shade600),
                const SizedBox(height: 4),
                CustomText(
                  time!,
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}