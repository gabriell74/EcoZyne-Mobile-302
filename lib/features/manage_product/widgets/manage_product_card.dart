import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageProductCard extends StatelessWidget {
  final Product product;
  final Future<bool> Function() onDelete;
  final VoidCallback onEdit;

  const ManageProductCard({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onEdit,
  });

  String formatDate(String? date) {
    if (date == null) return "-";
    final d = DateTime.tryParse(date);
    if (d == null) return "-";
    return DateFormat("dd MMM yyyy").format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: product.photo,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 400),
                    placeholder: (context, url) => Container(
                      height: 150,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: LoadingWidget(width: 60,),
                      ),
                    ),
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

                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                      onTap: () async {
                          await onDelete();
                      },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CustomText(
                product.productName,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CustomText(
                product.description,
                fontSize: 13,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      "Rp ${product.price}",
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustomText(
                      "Stok: ${product.stock}",
                      fontSize: 12,
                      color: Colors.green.shade900,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 14, color: Colors.green),
                  const SizedBox(width: 6),
                  CustomText(
                    formatDate(product.createdAt),
                    fontSize: 12,
                    color: Colors.black54,
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
