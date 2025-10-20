import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/question.dart';
import 'package:ecozyne_mobile/features/discussion_forum/screens/question_detail_screen.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final Question question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Material(
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
                question.question,
                fontWeight: FontWeight.w700,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontSize: 16,
                color: Colors.black87,
              ),
              const SizedBox(height: 6),
              CustomText(
                question.username,
                color: Colors.grey,
                fontSize: 13,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.favorite,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 4),
                  CustomText(
                    question.totalLike.toString(),
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.comment, size: 18, color: Colors.grey),
                  const SizedBox(width: 4),
                  CustomText(
                    question.totalComment.toString(),
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
