import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';

class PdfUploadWidget extends StatelessWidget {
  final String? selectedPdfPath;
  final VoidCallback onPickPdf;

  const PdfUploadWidget({
    super.key,
    required this.selectedPdfPath,
    required this.onPickPdf,
  });

  Widget _buildUploadBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 0),
        InkWell(
          onTap: onPickPdf,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFB9F5C6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    selectedPdfPath != null
                        ? File(selectedPdfPath!).path.split('/').last
                        : "Unggah file PDF",
                    color: Colors.black87,
                  ),
                ),
                const Icon(Icons.upload_file, color: Colors.black54),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              "Surat Pengajuan",
              fontWeight: FontWeight.bold,
            ),
            GestureDetector(
              onTap: () async {
                final url = Uri.parse(
                  'https://example.com/surat_pernyataan.pdf',
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child: const Text(
                'Download file',
                style: TextStyle(
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Transform.translate(
          offset: const Offset(0, -15),
          child: _buildUploadBox(),
        ),
      ],
    );
  }
}