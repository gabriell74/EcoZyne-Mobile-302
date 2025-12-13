import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class DateHeader extends StatelessWidget {
  final String date;
  const DateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          CustomText(date, fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
        ],
      ),
    );
  }
}