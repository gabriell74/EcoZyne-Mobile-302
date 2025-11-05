import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/question.dart';
import 'package:ecozyne_mobile/data/providers/question_provider.dart';
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

  final List<Map<String, String>> replies = [
    {
      "username": "AAA",
      "reply": "eco enzyme adalah cairan alami hasil fermentasi sampah organik seperti kulit buah."
    },
    {
      "username": "BBB",
      "reply": "eco enzyme bisa digunakan untuk pupuk tanaman dan pembersih alami."
    },
    {
      "username": "CCC",
      "reply": "proses pembuatannya sekitar 3 bulan, dengan bahan air, gula merah, dan limbah organik."
    },
    {
      "username": "DDD",
      "reply": "aku sudah coba bikin sendiri, hasilnya lumayan bagus untuk tanaman."
    },
    {
      "username": "EEE",
      "reply": "eco enzyme juga bisa bantu kurangi sampah rumah tangga, loh!"
    },
  ];

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuestionProvider questionProvider = context.watch<QuestionProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Forum Diskusi", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),

      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
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
                          fontSize: 16,
                        ),
                        SizedBox(height: 4),
                        CustomText(
                          widget.question.question,
                          fontSize: 15,
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
                    onTap: () {
                      questionProvider.toggleLike(widget.question.id);
                    },
                    child: Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) => ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                          child: Icon(
                            widget.question.isLiked ? Icons.favorite : Icons.favorite_border,
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
                child: ListView.builder(
                  itemCount: replies.length,
                  itemBuilder: (context, index) {
                    final item = replies[index];
                    return ReplyItem(
                      username: item['username']!,
                      reply: item['reply']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(
                color: Colors.grey.shade300)
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _replyController,
                  decoration: InputDecoration(
                    hintText: "Tulis balasan...",
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF55C173)),
                onPressed: () {
                  final text = _replyController.text.trim();
                  if (text.isEmpty) return;

                  setState(() {
                    replies.add({
                      "username": "Kamu",
                      "reply": text,
                    });
                  });

                  _replyController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
