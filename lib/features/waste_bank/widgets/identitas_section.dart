import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/utils/validators.dart';

class IdentitasSection extends StatelessWidget {
  final TextEditingController bankNameController;
  final FormFieldValidator<String>? validator;

  const IdentitasSection({
    super.key,
    required this.bankNameController,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            "Nama Bank Sampah",
            fontSize: 14,
            color: Colors.black54,
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: bankNameController,
              decoration: const InputDecoration(
                hintText: "Contoh: Bank Sampah Bersih Jaya",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              validator: validator ?? Validators.bankName,
            ),
          ),
        ],
      ),
    );
  }
}