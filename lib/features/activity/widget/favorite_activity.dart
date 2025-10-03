import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FavoriteActivity extends StatelessWidget {
  const FavoriteActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 130,
        child: InkWell(
          onTap: () {},
          child: Row(
            children: [
              Container(
                width: 120,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/cover2.png"),
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
                            "50/200",
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
          
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              "Jumat",
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          CustomText(
                            "03 Oktober 2025",
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
          
                      CustomText(
                        "Bersih-bersih Pantai Ocarina",
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
                            "Batam",
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
