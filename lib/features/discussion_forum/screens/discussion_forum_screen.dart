import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/question_provider.dart';
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
            Navigator.pushNamed(context, '/question');
          },
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
      body: CustomScrollView(
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
                          (q) => q.question.toLowerCase().contains(
                            _query.toLowerCase(),
                          ),
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
                delegate: SliverChildBuilderDelegate((context, index) {
                  final question = filtered[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13.0,
                      vertical: 6.0,
                    ),
                    child: QuestionCard(question: question),
                  );
                }, childCount: filtered.length),
              );
            },
          ),
        ],
      ),
    );
  }
}
