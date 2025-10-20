import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/question.dart';
import 'package:ecozyne_mobile/data/providers/auth_provider.dart';
import 'package:ecozyne_mobile/features/discussion_forum/screens/edit_question_screen.dart';
import 'package:ecozyne_mobile/features/discussion_forum/screens/question_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final VoidCallback? onEdit;

  const QuestionCard({super.key, required this.question, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUserId = authProvider.user?.id;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shadowColor: Colors.black.withAlpha(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QuestionDetailScreen(
                question: question,
              ),
            ),
          );
        },
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
                      question.question,
                      fontWeight: FontWeight.w700,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                if (currentUserId != null && currentUserId == question.userId)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey, size: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: const [
                            Icon(Icons.edit, size: 20, color: Colors.white),
                            SizedBox(width: 8),
                            CustomText(
                              "Edit Pertanyaan",
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                    color: Colors.black.withValues(alpha: 0.8),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditQuestionScreen(question: question),
                          ),
                        );
                      }
                    },
                  )
                ],
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
                  const Icon(Icons.favorite, size: 18, color: Colors.grey),
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
