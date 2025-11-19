import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/activity.dart';
import 'package:ecozyne_mobile/features/activity/screens/activity_detail_screen.dart';
import 'package:flutter/material.dart';

class LatestActivity extends StatelessWidget {
  final Activity activity;

  const LatestActivity({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 80,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityDetailScreen(activity: activity),
              ),
            );
          },
          child: Row(
            children: [

              SizedBox(width: 20,),

              SizedBox(
                width: 60,
                height: 60,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: activity.photo,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 400),
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),

                      CustomText(
                        activity.title,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          CustomText(
                            DateFormatter.formatDate(activity.startDate),
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              Icon(Icons.input_rounded, color: Color(0xFF55C173),),

              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
