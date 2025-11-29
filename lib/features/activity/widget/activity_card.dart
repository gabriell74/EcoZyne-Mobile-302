import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/login_required_dialog.dart';
import 'package:ecozyne_mobile/data/models/activity.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/activity/screens/activity_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = DateTime.now().isAfter(DateTime.parse(activity.dueDate));

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            height: 130,
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

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  activity.title,
                  fontSize: 14,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.green),
                    const SizedBox(width: 4),
                    Expanded(
                      child: CustomText(
                        activity.location,
                        color: Colors.grey,
                        fontSize: 12,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CustomText(
                  DateFormatter.formatDate(activity.startDate),
                  color: Colors.grey,
                  fontSize: 12,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF649B71),
                      side: const BorderSide(color: Color(0xFF649B71)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      final userProvider = context.read<UserProvider>();

                      if (userProvider.isGuest || userProvider.user == null) {
                        showDialog(
                          context: context,
                          builder: (context) => const LoginRequiredDialog(),
                        );
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivityDetailScreen(activity: activity),
                            )
                        );
                      }
                    },
                    child: Text(isCompleted ? "Lihat Kegiatan" : "Daftar"),
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