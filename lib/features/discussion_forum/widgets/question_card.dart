import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/discussion_forum/screens/question_detail_screen.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => QuestionDetailScreen(

                  ),
              )
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Resep Pupuk Eco Enzyme",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                const SizedBox(height: 6),
                CustomText(
                  "Orang Orang",
                  color: Colors.grey,
                  fontSize: 13,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.thumb_up_alt_outlined,
                        size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    CustomText(
                      "50 Suka",
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.comment, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    CustomText(
                      "75 Komentar",
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
