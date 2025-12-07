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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(icon, color: color),
                ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      subtitle,
                      color: subtitleColor.withValues(alpha: 0.5),
                    ),
                    if (description != null)
                      CustomText(
                        description!,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                  ],
                ),
              ),

              if (time != null)
                SizedBox(width: 10,),
                CustomText(
                  time!,
                  color: Colors.grey,
                  fontSize: 12,
                ),
            ],
          ),
        ),

        Divider(
          color: Colors.grey.withValues(alpha: 0.4),
          thickness: 1,
          height: 0,
        ),
      ],
    );

  }

}
