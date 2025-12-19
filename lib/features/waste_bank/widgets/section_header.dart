import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: CustomText(
        title,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }
}