import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FavoriteActivity extends StatelessWidget {
  final Map<String,dynamic> activity;

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
          onTap: () {},
          child: Row(
            children: [
              Container(
                width: 120,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(activity["image"]),
                    fit: BoxFit.cover,
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
                            activity["quota"],
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
                            activity["date"],
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
          
                      CustomText(
                        activity["title"],
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
                            activity["location"],
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
