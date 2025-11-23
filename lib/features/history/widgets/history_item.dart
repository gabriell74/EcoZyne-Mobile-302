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
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 2),
                CustomText(
                  subtitle,
                  color: subtitleColor.withValues(alpha: 0.5),
                ),
                CustomText(
                  description ?? "",
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          if (time != null)
            Text(
              time!,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
        ],
      ),
    );
  }

}
