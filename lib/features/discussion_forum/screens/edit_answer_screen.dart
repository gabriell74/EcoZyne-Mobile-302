import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/data/models/answer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/answer_provider.dart';

class EditAnswerScreen extends StatefulWidget {
  final Answer answer;

  const EditAnswerScreen({super.key, required this.answer});

  @override
  State<EditAnswerScreen> createState() => _EditAnswerScreenState();
}

class _EditAnswerScreenState extends State<EditAnswerScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.answer.answer);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnswerProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Edit Jawaban", fontWeight: FontWeight.bold, fontSize: 18),
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
                    "Jawaban",
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
        
                        final success = await provider.editAnswer(widget.answer.id, newText);
        
                        if (!mounted) return;
        
                        if (success) {
                          showSuccessTopSnackBar(
                              context, "Jawaban diperbarui!");
                          _controller.clear();
                        } else {
                          showErrorTopSnackBar(
                              context, "Gagal memperbarui jawaban. Coba lagi!");
                        }
        
                        Navigator.pop(context);
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
