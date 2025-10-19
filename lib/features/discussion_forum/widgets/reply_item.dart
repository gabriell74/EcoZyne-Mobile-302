import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ReplyItem extends StatelessWidget {
  final String username;
  final String reply;

  const ReplyItem({
    super.key,
    required this.username,
    required this.reply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    username,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    reply,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}