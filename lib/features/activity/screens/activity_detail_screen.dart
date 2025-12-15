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

class ActivityDetailScreen extends StatefulWidget {
  final Activity activity;

  const ActivityDetailScreen({super.key, required this.activity});

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<ActivityProvider>().checkRegistrationStatus(widget.activity.id);
    });
  }

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
    final bool isSuccess = await activityProvider.activityRegister(widget.activity.id);

    if (context.mounted) Navigator.pop(context);

    if (isSuccess) {
      context.read<ActivityProvider>().checkRegistrationStatus(widget.activity.id);

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
    final activity = widget.activity;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Detail Kegiatan", fontWeight: FontWeight.bold, fontSize: 18),
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
                  // IMAGE WITH HERO ANIMATION
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
                            child: LoadingWidget(width: 60),
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

                  const SizedBox(height: 20),

                  Consumer<ActivityProvider>(
                    builder: (context, provider, _) {
                      final currentActivity = provider.activities.firstWhere(
                            (act) => act.id == activity.id,
                        orElse: () => activity,
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TITLE
                            CustomText(
                              currentActivity.title,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),

                            const SizedBox(height: 16),

                            // LOCATION & QUOTA CHIPS
                            Row(
                              children: [
                                Expanded(
                                  child: _infoChip(
                                    icon: Icons.location_on,
                                    label: currentActivity.location,
                                    color: Colors.red.shade400,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _infoChip(
                                  icon: Icons.people,
                                  label: "${currentActivity.currentQuota}/${currentActivity.quota}",
                                  color: Colors.blue.shade400,
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // DATE SECTIONS WITH CLEAR LABELS
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.teal.shade100),
                              ),
                              child: Column(
                                children: [
                                  _dateInfoRow(
                                    label: "Periode Pendaftaran",
                                    icon: Icons.app_registration,
                                    dateRange:
                                    "${DateFormatter.formatDate(currentActivity.regisStartDate)} - ${DateFormatter.formatDate(currentActivity.regisDueDate)}",
                                    iconColor: Colors.orange.shade600,
                                  ),
                                  const SizedBox(height: 12),
                                  Divider(height: 1, color: Colors.teal.shade200),
                                  const SizedBox(height: 12),
                                  _dateInfoRow(
                                    label: "Periode Kegiatan",
                                    icon: Icons.event_available,
                                    dateRange:
                                    "${DateFormatter.formatDate(currentActivity.startDate)} - ${DateFormatter.formatDate(currentActivity.dueDate)}",
                                    iconColor: Colors.green.shade600,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // DESCRIPTION SECTION
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.description, size: 20, color: Color(0xFF55C173)),
                                      const SizedBox(width: 8),
                                      const CustomText(
                                        "Deskripsi Kegiatan",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF55C173),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  CustomText(
                                    currentActivity.description,
                                    color: Colors.grey.shade700,
                                    height: 1.5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // BOTTOM BUTTON
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Consumer<ActivityProvider>(
                builder: (context, provider, _) {

                  final bool alreadyRegistered = provider.isActivityRegistered(activity.id);
                  final bool checking = provider.isCheckingStatus;

                  if (checking) {
                    return SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: null,
                        child: const LoadingWidget(height: 40, width: 40),
                      ),
                    );
                  }

                  final bool isCompleted = DateTime.now().isAfter(DateTime.parse(activity.dueDate));
                  final bool isFull = activity.currentQuota == activity.quota;
                  final DateTime? regisStartDate =
                  DateTime.tryParse(activity.regisStartDate);

                  final bool registrationNotOpened =
                      regisStartDate != null && regisStartDate.isAfter(DateTime.now());

                  String buttonText;
                  VoidCallback? action;
                  Color? buttonColor;
                  IconData? buttonIcon;

                  if (isCompleted) {
                    buttonText = "Kegiatan Sudah Selesai";
                    action = null;
                    buttonColor = Colors.grey.shade400;
                    buttonIcon = Icons.event_busy;
                  }
                  else if (registrationNotOpened) {
                    buttonText = "Pendaftaran Belum Dibuka";
                    action = null;
                    buttonColor =  Colors.grey.shade400;
                    buttonIcon = Icons.event_note;
                  }
                  else if (isFull) {
                    buttonText = "Kuota Penuh";
                    action = null;
                    buttonColor = Colors.orange.shade400;
                    buttonIcon = Icons.people_alt;
                  }
                  else if (alreadyRegistered) {
                    buttonText = "Sudah Terdaftar";
                    action = null;
                    buttonColor = Colors.teal.shade600;
                    buttonIcon = Icons.check_circle;
                  }
                  else {
                    buttonText = "Daftar Kegiatan";
                    buttonColor = const Color(0xFF55C173);
                    buttonIcon = Icons.how_to_reg;
                    action = () {
                      final userProvider = context.read<UserProvider>();
                      if (userProvider.isGuest || userProvider.user == null) {
                        showDialog(
                          context: context,
                          builder: (context) => const LoginRequiredDialog(),
                        );
                      } else {
                        _showConfirmDialog(context);
                      }
                    };
                  }

                  return SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: action,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        elevation: action != null ? 2 : 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...[
                            Icon(buttonIcon, size: 20),
                            const SizedBox(width: 8),
                          ],
                          CustomText(
                            buttonText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: CustomText(
              label,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateInfoRow({
    required String label,
    required IconData icon,
    required String dateRange,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                label,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
              const SizedBox(height: 4),
              CustomText(
                dateRange,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}