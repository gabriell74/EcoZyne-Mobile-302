import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/utils/price_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/product.dart';
import 'package:ecozyne_mobile/features/marketplace/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';

class MarketplaceCard extends StatelessWidget {
  final Product product;
  // final Future<void> Function() onPressed;

  const MarketplaceCard({super.key, required this.product, /* required this.onPressed */});

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
                return ProductDetailScreen(product: product);
              },
            )
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Hero(
                tag: 'product-photo-tag-${product.id}',
                child: CachedNetworkImage(
                  imageUrl: product.photo,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 400),
                  placeholder: (context, url) =>  const SizedBox(height: 150),
                  errorWidget: (context, url, error) => Container(
                    height: 150,
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: CustomText(
                product.productName,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomText(
                product.price.toCurrency,
                fontSize: 16,
                maxLines: 2,
                fontWeight: FontWeight.bold,
                textOverflow: TextOverflow.ellipsis,
                color: Colors.pink,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.recycling_outlined, color: Colors.green,),
                  SizedBox(width: 5,),
                  Expanded(
                    child: CustomText(product.wasteBankName ?? 'Bank Sampah',
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
