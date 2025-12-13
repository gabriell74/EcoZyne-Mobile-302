import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class BuildImageSection extends StatelessWidget {
  final int id;
  final String tagPrefix;
  final String photo;

  const BuildImageSection({super.key, required this.id, required this.photo, required this.tagPrefix});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Hero(
        tag: '$tagPrefix-photo-tag-$id',
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: CachedNetworkImage(
            imageUrl: photo,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey.shade100,
              child: const Center(
                child: LoadingWidget(width: 60),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade50,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_rounded,
                      color: Colors.grey.shade400,
                      size: 80,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      "Gambar tidak tersedia",
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
