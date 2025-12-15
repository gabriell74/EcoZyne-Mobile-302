import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/models/question.dart';
import 'package:ecozyne_mobile/data/providers/question_provider.dart';

class EditQuestionScreen extends StatefulWidget {
  final Question question;

  const EditQuestionScreen({super.key, required this.question});

  @override
  State<EditQuestionScreen> createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.question.question);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuestionProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Edit Pertanyaan", fontWeight: FontWeight.bold, fontSize: 18),
        centerTitle: true,
      ),
      body: AppBackground(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    "Pertanyaan",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
        
                        final newText = _controller.text.trim();
                        if (newText.isEmpty) return;
        
                        final success = await provider.updateQuestion(widget.question.id, newText);
        
                        if (!mounted) return;
        
                        if (success) {
                          showSuccessTopSnackBar(context, "Pertanyaan diperbarui!");
                          Navigator.pop(context);
                        } else {
                          showErrorTopSnackBar(context, "Gagal memperbarui pertanyaan. Coba lagi!");
                        }
                      },
        
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.black),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 10,
                        ),
                      ),
                      child: const CustomText(
                        "Simpan Perubahan",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            if (provider.isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.4),
                child: const Center(
                  child: LoadingWidget(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
