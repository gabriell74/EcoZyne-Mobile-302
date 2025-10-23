import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/marketplace/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';

class MarketplaceCard extends StatelessWidget {
  final Map<String, String> item;

  const MarketplaceCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ProductDetailScreen();
              },
            )
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(item["image"]!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: CustomText(
                item["name"]!,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomText(
                item["price"]!,
                fontSize: 16,
                maxLines: 2,
                fontWeight: FontWeight.bold,
                textOverflow: TextOverflow.ellipsis,
                color: Colors.black87,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, color: Colors.green,),
                  SizedBox(width: 5,),
                  Expanded(
                    child: CustomText("Bank Sampah Poltek",
                      textOverflow: TextOverflow.ellipsis,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
