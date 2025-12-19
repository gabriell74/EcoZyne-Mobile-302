import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/pdf_upload_widget.dart';

class DocumentSection extends StatelessWidget {
  final String? selectedPdfPath;
  final Function() onPickPdf;

  const DocumentSection({
    super.key,
    required this.selectedPdfPath,
    required this.onPickPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            "Surat Pengajuan (PDF)",
            fontSize: 14,
            color: Colors.black54,
          ),
          const SizedBox(height: 8),
          PdfUploadWidget(
            selectedPdfPath: selectedPdfPath,
            onPickPdf: onPickPdf,
          ),
          const SizedBox(height: 4),
          const CustomText(
            "Maksimal 5MB",
            fontSize: 12,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}