import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/login_required_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/activity_provider.dart';
import 'package:ecozyne_mobile/data/models/activity.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class ActivityDetailScreen extends StatelessWidget {
  final Activity activity;

  const ActivityDetailScreen({super.key, required this.activity});

  Future<void> _showConfirmDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (confirmDialogContext) => ConfirmationDialog(
        "Anda yakin daftar kegiatan ini?",
        onTap: () {
          Navigator.pop(confirmDialogContext, true);
        },
      ),
    );

    if (confirmed != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingWidget(height: 100),
    );

    final activityProvider = context.read<ActivityProvider>();
    final bool isSuccess = await activityProvider.activityRegister(activity.id);

    if (context.mounted) Navigator.pop(context);

    if (isSuccess) {
      showSuccessTopSnackBar(
        context,
        "Berhasil Mendaftar Kegiatan",
        icon: const Icon(Icons.volunteer_activism_outlined),
        size: 65,
      );
    } else {
      showErrorTopSnackBar(context, activityProvider.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = DateTime.now().isAfter(DateTime.parse(activity.dueDate));
    final bool isFull = activity.currentQuota == activity.quota;

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
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Hero(
                      tag: 'activity-photo-tag-${activity.id}',
                      child: CachedNetworkImage(
                        imageUrl: activity.photo,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 400),
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: LoadingWidget(width: 60,),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<ActivityProvider>(
                    builder: (context, provider, _) {
                      final currentActivity = provider.activities.firstWhere(
                            (act) => act.id == activity.id,
                        orElse: () => activity,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    currentActivity.title,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                CustomText(
                                  '${currentActivity.currentQuota}/${currentActivity.quota}',
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
                                const Icon(Icons.location_on, size: 16, color: Colors.green),
                                const SizedBox(width: 4),
                                CustomText(currentActivity.location, color: Colors.black54),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomText("Tanggal Pendaftaran", fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.green),
                                const SizedBox(width: 4),
                                CustomText(
                                  '${DateFormatter.formatDate(currentActivity.startDate)} - ${DateFormatter.formatDate(currentActivity.dueDate)}',
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomText(
                              "Tanggal Kegiatan Berlangsung",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.green),
                                const SizedBox(width: 4),
                                CustomText(
                                  '${DateFormatter.formatDate(currentActivity.startDate)} - ${DateFormatter.formatDate(currentActivity.dueDate)}',
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CustomText(
                              currentActivity.description,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      );
                    },
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
                  onPressed: isCompleted || isFull
                      ? null
                      : () {
                    final userProvider = context.read<UserProvider>();

                    if (userProvider.isGuest || userProvider.user == null) {
                      showDialog(
                        context: context,
                        builder: (context) => const LoginRequiredDialog(),
                      );
                    } else {
                      _showConfirmDialog(context);
                    }
                  },
                  child: CustomText(
                    isCompleted
                        ? "Kegiatan Sudah Selesai"
                        : isFull
                        ? "Kuota Penuh"
                        : "Daftar Kegiatan",
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
