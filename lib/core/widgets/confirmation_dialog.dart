import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ConfirmationDialog(this.title, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: CustomText(
          title,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: SizedBox(
                width: 110,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF649B71),
                    side: const BorderSide(color: Color(0xFF649B71)),
                  ),
                  onPressed: onTap,
                  child: const Text("Yakin"),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: SizedBox(
                width: 110,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
