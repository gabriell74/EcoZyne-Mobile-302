import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/question_provider.dart';
import 'package:ecozyne_mobile/features/discussion_forum/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscussionForumScreen extends StatefulWidget {
  const DiscussionForumScreen({super.key});

  @override
  State<DiscussionForumScreen> createState() => _DiscussionForumScreenState();
}

class _DiscussionForumScreenState extends State<DiscussionForumScreen> {

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
        title: CustomText("Forum Diskusi", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF7F8FA),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF55C173),
          onPressed: () {
            Navigator.pushNamed(context, '/question');
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: AppBackground(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Cari topik...",
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Consumer<QuestionProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: LoadingWidget()),
                  );
                }

                if (provider.isSearching && provider.filteredQuestions.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: EmptyState(
                          connected: true,
                          message: "Pertanyaan tidak ditemukan.",
                        ),
                      ),
                    ),
                  );
                }

                if (!provider.isSearching && provider.questions.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: EmptyState(
                          connected: provider.connected,
                          message: provider.message,
                        ),
                      ),
                    ),
                  );
                }


                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final question = provider.questions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: QuestionCard(question: question),
                      );
                    },
                    childCount: provider.questions.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
