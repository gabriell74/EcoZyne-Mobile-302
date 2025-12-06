import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final String? photo;
  final String title;
  final String subtitle;
  final Color subtitleColor;
  final String? description;
  final String? time;

  const HistoryItem({
    super.key,
    this.icon,
    this.color,
    this.photo,
    required this.title,
    required this.subtitle,
    this.subtitleColor = Colors.black,
    this.description,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (photo == null)
            Container(
              decoration: BoxDecoration(
                color: color?.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: color),
            ),

          if (icon == null && photo != null)
            SizedBox(
              width: 60,
              height: 60,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: photo!,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 400),
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: LoadingWidget(width: 60,),
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

          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 2),
                CustomText(
                  subtitle,
                  color: subtitleColor.withValues(alpha: 0.5),
                ),
                CustomText(
                  description ?? "",
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          if (time != null)
            Text(
              time!,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
        ],
      ),
    );
  }

}
