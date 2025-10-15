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
                "Berhasil Mendaftar di Tanam Pohon Bersama",
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFF649B71),
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/cover3.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    "Tanam Pohon Bersama",
                    fontSize: 14,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                  Row(
                    children: const [
                      Icon(Icons.location_on, size: 14, color: Colors.green),
                      SizedBox(width: 4),
                      CustomText("Batam", color: Colors.grey, fontSize: 12),
                    ],
                  ),
                  CustomText(
                    "12 Agustus 2025, 14.30",
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF649B71),
                        side: const BorderSide(color: Color(0xFF649B71)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                      onPressed: () => _showConfirmDialog(context),
                      child: const Text("Daftar"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

