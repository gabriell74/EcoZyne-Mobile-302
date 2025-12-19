import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/build_form_field.dart';
import 'package:ecozyne_mobile/core/utils/validators.dart';

class ContactSection extends StatelessWidget {
  final TextEditingController whatsappController;
  final TextEditingController descriptionController;

  const ContactSection({
    super.key,
    required this.whatsappController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            "Nomor WhatsApp",
            fontSize: 14,
            color: Colors.black54,
          ),
          const SizedBox(height: 8),
          BuildFormField(
            label: "08xx-xxxx-xxxx",
            controller: whatsappController,
            validator: Validators.whatsapp,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone,
          ),

          const SizedBox(height: 16),
          const CustomText(
            "Deskripsi Bank Sampah",
            fontSize: 14,
            color: Colors.black54,
          ),
          const SizedBox(height: 8),
          BuildFormField(
            label: "Jelaskan profil dan jenis sampah yang ditampung",
            controller: descriptionController,
            maxLines: 4,
            validator: Validators.description,
            hintText: "Bank Sampah kami berfokus pada daur ulang plastik dan kertas...",
          ),
        ],
      ),
    );
  }
}