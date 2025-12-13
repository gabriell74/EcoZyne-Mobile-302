import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/waste_bank.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/waste_bank_detail_card.dart';
import 'package:flutter/material.dart';

class WasteBankDetailScreen extends StatefulWidget {
  final WasteBank wasteBank;
  const WasteBankDetailScreen({super.key, required this.wasteBank});

  @override
  State<WasteBankDetailScreen> createState() => _WasteBankDetailScreenState();
}

class _WasteBankDetailScreenState extends State<WasteBankDetailScreen> {
  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        "Anda yakin memilih Bank Sampah ini?",
        onTap: () {
          Navigator.pop(context);

          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Berhasil memilih\nBank Sampah",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Bank Sampah", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage(''),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  WasteBankDetailCard(
                    name: widget.wasteBank.wasteBankName,
                    location: widget.wasteBank.wasteBankLocation,
                    imageUrl: widget.wasteBank.photo,
                  ),

                  SizedBox(height: 12),

                  CustomText(
                    "Tentang Bank Sampah",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),

                  SizedBox(height: 12),

                  CustomText(
                    "Bank Sampah Oke menerima berbagai jenis sampah organik seperti dun kering, sisa buah dan sisa sayur. Setiap sampah yang disetorkan akan ditimbang dan dicatat sebagai poin yang dapat ditukar barang kebutuhan sehari-hari.",
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _showConfirmDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB9F5C6),
                ),
                child: const CustomText(
                  "Setor Sampah",
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
