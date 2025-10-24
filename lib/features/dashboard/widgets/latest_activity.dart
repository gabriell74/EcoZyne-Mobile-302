import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/activity/screens/activity_detail_screen.dart';
import 'package:flutter/material.dart';

class LatestActivity extends StatelessWidget {
  final Map<String, dynamic> activity;

  const LatestActivity({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const Padding(
          padding:  EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "Kegiatan Terbaru",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 9,
        ),

        Card(
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

                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(activity["image"]),
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
                            activity["title"],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              CustomText(
                                activity["startDate"],
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
        ),
      ],
    );
  }
}
