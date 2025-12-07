import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class BuildFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final int maxLines;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final String? hintText;
  final bool isDate;
  final VoidCallback? onTap;
  final bool obscureText;
  final bool enabled;

  const BuildFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.hintText,
    this.isDate = false,
    this.onTap,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: CustomText(
            label,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),

          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            maxLines: maxLines,
            keyboardType: keyboardType,
            readOnly: isDate,
            obscureText: obscureText,
            enabled: enabled,
            onTap: isDate ? onTap : null,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade900,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.white,

              prefixIcon: prefixIcon != null
                  ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Icon(
                  prefixIcon,
                  color: Colors.grey.shade500,
                  size: 22,
                ),
              )
                  : null,

              suffixIcon: suffixIcon != null
                  ? IconButton(
                icon: Icon(
                  suffixIcon,
                  color: Colors.grey.shade500,
                  size: 22,
                ),
                onPressed: onSuffixIconTap,
              )
                  : isDate
                  ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
              )
                  : null,

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                  width: 2,
                ),
              ),

              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade100,
                  width: 2,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.green.shade400,
                  width: 2,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red.shade400,
                  width: 2,
                ),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red.shade500,
                  width: 2,
                ),
              ),

              errorStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.red.shade600,
                height: 1.4,
              ),

              errorMaxLines: 2,

              contentPadding: EdgeInsets.symmetric(
                horizontal: prefixIcon != null ? 8 : 16,
                vertical: maxLines > 1 ? 14 : 16,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}