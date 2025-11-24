import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class BuildFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final int maxLines;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? hintText;
  final bool isDate;
  final VoidCallback? onTap;

  const BuildFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.hintText,
    this.isDate = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, fontSize: 14, fontWeight: FontWeight.bold),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          readOnly: isDate,
          onTap: isDate ? onTap : null,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
