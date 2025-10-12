import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/features/discussion_forum/widgets/question_card.dart';
import 'package:flutter/material.dart';

class DiscussionForumScreen extends StatelessWidget {
  const DiscussionForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF55C173),
          onPressed: () {},
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: AppBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 100,
              backgroundColor: const Color(0xFF55C173),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                title: const Text(
                  "Forum Diskusi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF55C173), Color(0xFF2EB67D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
        
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
        
            SliverList(
              delegate: SliverChildListDelegate([
                QuestionCard(),
                QuestionCard(),
                QuestionCard(),
                QuestionCard(),
                QuestionCard(),
                QuestionCard(),
                QuestionCard(),
        
                SizedBox(height: 20,)
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
