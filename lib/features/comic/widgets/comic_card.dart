import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class ComicCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String createdAt;
  final VoidCallback onTap;

  const ComicCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.createdAt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 400),
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: LoadingWidget(),
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
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    DateFormatter.formatDate(createdAt),
                    fontSize: 12,
                    color: Colors.grey,
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
