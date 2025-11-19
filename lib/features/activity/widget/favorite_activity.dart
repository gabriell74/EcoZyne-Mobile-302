import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/activity.dart';
import 'package:ecozyne_mobile/features/activity/screens/activity_detail_screen.dart';
import 'package:flutter/material.dart';

class FavoriteActivity extends StatelessWidget {
  final Activity? activity;

  const FavoriteActivity({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 130,
        child: InkWell(
          onTap: () {
            if (activity != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ActivityDetailScreen(activity: activity!),
                )
              );
            }
          },
          child: Row(
            children: [
              Container(
                width: 120,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(activity?.photo ?? ''),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) => const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: activity?.photo ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                      ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                  ),
                ),
              ),
          
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
          
                          const SizedBox(),

                          CustomText(
                            '${activity?.currentQuota ?? 0}/${activity?.quota ?? 0}',
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
          
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          CustomText(
                            activity?.startDate ?? '',
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
          
                      CustomText(
                        activity?.title ?? 'No Title',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
          
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          CustomText(
                            activity?.location ?? 'No Location',
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
