import 'package:ecozyne_mobile/core/utils/user_helper.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/login_required_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/models/question.dart';
import 'package:ecozyne_mobile/data/providers/answer_provider.dart';
import 'package:ecozyne_mobile/data/providers/question_provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/discussion_forum/screens/edit_answer_screen.dart';
import 'package:ecozyne_mobile/features/discussion_forum/widgets/reply_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionDetailScreen extends StatefulWidget {
  final Question question;

  const QuestionDetailScreen({super.key, required this.question});

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AnswerProvider>().fetchAnswers(widget.question.id);
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionProvider = context.watch<QuestionProvider>();
    final answerProvider = context.watch<AnswerProvider>();

    void _showConfirmDeleteDialog(int answerId) {
      showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          "Apakah kamu yakin ingin menghapus jawaban ini?",
          onTap: () async {
            final success = await context.read<AnswerProvider>().deleteAnswer(
              answerId,
            );

            if (!mounted) return;

            Navigator.pop(context);

            if (success) {
              showSuccessTopSnackBar(
                context,
                "Berhasil menghapus jawaban",
                icon: const Icon(Icons.check_circle),
              );
            } else {
              showErrorTopSnackBar(
                context,
                context.read<QuestionProvider>().message,
              );
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Forum Diskusi", fontWeight: FontWeight.bold, fontSize: 18),
        centerTitle: true,
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.chat_bubble_outline, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          widget.question.username,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          widget.question.question,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    "Balasan",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final isLoggedIn = UserHelper.isLoggedIn(context);
                      if (!isLoggedIn) {
                        showDialog(
                          context: context,
                          builder: (context) => LoginRequiredDialog(),
                        );
                      } else {
                        await questionProvider.toggleLike(widget.question.id);
                      }
                    },
                    child: Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            widget.question.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            key: ValueKey(widget.question.isLiked),
                            color: Colors.red,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          widget.question.totalLike.toString(),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(height: 2, width: 60, color: Colors.blueAccent),
              const SizedBox(height: 16),
              Expanded(
                child: answerProvider.isLoading
                    ? const Center(child: LoadingWidget(height: 80))
                    : answerProvider.answers.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: EmptyState(
                              connected: answerProvider.connected,
                              message: answerProvider.message,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: answerProvider.answers.length,
                        itemBuilder: (context, index) {
                          final answer = answerProvider.answers[index];
                          return ReplyItem(
                            answer: answer,
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditAnswerScreen(answer: answer),
                                ),
                              );
                            },
                            onDelete: (id) {
                              _showConfirmDeleteDialog(answer.id);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 6,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _replyController,
                  decoration: InputDecoration(
                    hintText: "Tulis balasan...",
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                        width: 1.2,
                      ),
                    ),
                    filled: false,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF55C173)),
                onPressed: () async {
                  final userProvider = context.read<UserProvider>();
        
                  if (userProvider.isGuest || userProvider.user == null) {
                    showDialog(
                      context: context,
                      builder: (context) => const LoginRequiredDialog(),
                    );
                  } else {
                    final text = _replyController.text.trim();
                    if (text.isEmpty) return;
        
                    bool success = await context
                        .read<AnswerProvider>()
                        .createAnswer(widget.question.id, text);
        
                    if (success) {
                      if (!mounted) return;
                      _replyController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: CustomText(
                            "Mengirim jawaban...",
                            color: Colors.black,
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.white,
                        ),
                      );
                    } else {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: CustomText(
                            context.read<AnswerProvider>().message,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
