import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuestionProvider questionProvider = context.watch<QuestionProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Forum Dskusi", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: questionProvider.isLoading ? LoadingWidget()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              "Tulis Pertanyaan",
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
                controller: _questionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Ketik pertanyaanmu di sini...",
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
                  final text = _questionController.text.trim();
                  if (text.isEmpty) return;

                  final success = await questionProvider.addQuestion(text);

                  if (!mounted) return;

                  if (success) {
                    showSuccessTopSnackBar(context, "Pertanyaanmu berhasil dibuat!");
                    _questionController.clear();
                    Navigator.pop(context);
                  } else {
                    showErrorTopSnackBar(context, "Gagal membuat pertanyaan. Coba lagi!");
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
                  "Buat Pertanyaan",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
