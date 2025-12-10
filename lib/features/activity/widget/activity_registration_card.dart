import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/models/activity_registration.dart';
import 'package:flutter/material.dart';

class ActivityRegistrationCard extends StatelessWidget {
  final ActivityRegistration registration;

  const ActivityRegistrationCard({super.key, required this.registration});

  @override
  Widget build(BuildContext context) {
    final activity = registration.activity;

    return Card(
      elevation: 5,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: activity.photo,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: LoadingWidget(width: 60)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  activity.title,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                CustomText(
                  activity.description,
                  fontSize: 14,
                  maxLines: 3,
                  textOverflow: TextOverflow.ellipsis,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _infoChip(
                        icon: Icons.location_on,
                        label: activity.location,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _infoChip(
                      icon: Icons.people,
                      label: "${activity.currentQuota}/${activity.quota}",
                      color: Colors.blue.shade400,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(12),
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
                        "${DateFormatter.formatDate(activity.regisStartDate)} - ${DateFormatter.formatDate(activity.regisDueDate)}",
                        iconColor: Colors.orange.shade600,
                      ),
                      const SizedBox(height: 10),
                      Divider(height: 1, color: Colors.teal.shade200),
                      const SizedBox(height: 10),
                      _dateInfoRow(
                        label: "Periode Kegiatan",
                        icon: Icons.event_available,
                        dateRange:
                        "${DateFormatter.formatDate(activity.startDate)} - ${DateFormatter.formatDate(activity.dueDate)}",
                        iconColor: Colors.green.shade600,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF55C173),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 6),
                      CustomText(
                        "Terdaftar pada ${DateFormatter.formatDate(registration.createdAt)}",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: CustomText(
              label,
              fontSize: 13,
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
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                label,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
              const SizedBox(height: 2),
              CustomText(
                dateRange,
                fontSize: 14,
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