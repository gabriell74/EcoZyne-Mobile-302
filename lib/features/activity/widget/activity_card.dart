import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/activity/screens/activity_detail_screen.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final Map<String,dynamic> activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "activity-image-${activity["title"]}",
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(activity["image"]),
                    fit: BoxFit.cover,
                  ),
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
                      activity["title"],
                      fontSize: 14,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.green),
                        SizedBox(width: 4),
                        CustomText(activity["location"], color: Colors.grey, fontSize: 12),
                      ],
                    ),
                    CustomText(
                      activity["startDate"],
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivityDetailScreen(activity: activity),
                            )
                          );
                        },
                        child: const Text("Daftar"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

