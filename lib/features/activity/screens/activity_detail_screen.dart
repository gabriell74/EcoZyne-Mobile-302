import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';

class ActivityDetailScreen extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ActivityDetailScreen({super.key, required this.activity});

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        "Anda yakin daftar kegiatan ini?",
        onTap: () {
          showSuccessTopSnackBar(
            context,
            "Berhasil Mendaftar Kegiatan",
            icon: const Icon(Icons.volunteer_activism_outlined),
            size: 65,
          );
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const CustomText(
          'Detail Aktivitas',
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color(0xFF55C173),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: "activity-image-${activity["title"]}",
                    child: Image.asset(
                      activity['image'],
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            activity['title'],
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        CustomText(
                          '${activity['currentQuota']}/${activity['maxQuota']}',
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        CustomText(activity['location'], color: Colors.black54),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          '${activity['startDate']} - ${activity['dueDate']}',
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CustomText(
                      activity['description'],
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => _showConfirmDialog(context),
                  child: const CustomText(
                    "Daftar Kegiatan",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
