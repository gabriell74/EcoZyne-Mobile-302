import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/login_required_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/question_provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/discussion_forum/screens/edit_question_screen.dart';
import 'package:ecozyne_mobile/features/discussion_forum/widgets/question_card.dart';
import 'package:ecozyne_mobile/features/discussion_forum/widgets/search_discussion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscussionForumScreen extends StatefulWidget {
  const DiscussionForumScreen({super.key});

  @override
  State<DiscussionForumScreen> createState() => _DiscussionForumScreenState();
}

class _DiscussionForumScreenState extends State<DiscussionForumScreen> {
  String _query = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionProvider>().getQuestions();
    });
  }

  void _showConfirmDeleteDialog(int questionId) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        "Apakah kamu yakin ingin menghapus pertanyaan ini?",
        onTap: () async {
          final success = await context.read<QuestionProvider>().deleteQuestion(questionId);

          if (!mounted) return;

          Navigator.pop(context);

          if (success) {
            showSuccessTopSnackBar(
              context,
              "Berhasil menghapus pertanyaan",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Forum Diskusi", color: Colors.black),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF55C173),
          onPressed: () {
            final userProvider = context.read<UserProvider>();

            if (userProvider.isGuest || userProvider.user == null) {
              showDialog(
                context: context,
                builder: (context) => const LoginRequiredDialog(),
              );
            } else {
              Navigator.pushNamed(context, '/question');
            }
          },
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
      body: AppBackground(
        child: RefreshIndicator(
          onRefresh: () async => await context.read<QuestionProvider>().getQuestions(),
          color: Colors.black,
          backgroundColor: const Color(0xFF55C173),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: SearchDiscussion(
                    onSearch: (query) {
                      setState(() {
                        _query = query;
                      });
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8),
                  child: CustomText(
                    "Temukan pertanyaan menarik",
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              Consumer<QuestionProvider>(
                builder: (context, provider, child) {
                  final questions = provider.questions;

                  final filtered = _query.isEmpty
                      ? questions
                      : questions
                      .where(
                        (q) => q.question.toLowerCase().contains(_query.toLowerCase()),
                  )
                      .toList();

                  if (provider.isLoading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: LoadingWidget()),
                    );
                  }

                  if (!provider.connected || questions.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: EmptyState(
                          connected: provider.connected,
                          message: provider.message,
                        ),
                      ),
                    );
                  }

                  if (filtered.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: EmptyState(
                          connected: true,
                          message: "Pertanyaan tidak ditemukan.",
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final question = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 6.0),
                          child: QuestionCard(
                            question: question,
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditQuestionScreen(question: question),)
                              );
                            },
                            onDelete: (id) {
                              _showConfirmDeleteDialog(id);
                            },
                          ),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
