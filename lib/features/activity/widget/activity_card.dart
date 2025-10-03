import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key});

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        "Anda yakin daftar kegiatan ini?",
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText(
                "Berhasil Mendaftar",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenSize.height * 0.22,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/cover1.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Tanam Pohon Bersama",
                  fontSize: 15,
                  textOverflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  fontWeight: FontWeight.bold,
                ),
                CustomText("Batam", color: Colors.grey, fontSize: 12),
                CustomText(
                  "12 Agustus 2025, 14.30",
                  color: Colors.grey,
                  fontSize: 12,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF649B71),
                      side: const BorderSide(color: Color(0xFF649B71) ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _showConfirmDialog(context),
                    child: const Text("Daftar"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
