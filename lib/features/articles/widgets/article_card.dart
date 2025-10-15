import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/article.dart';
import 'package:ecozyne_mobile/features/articles/screens/article_detail_screen.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Card(
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ArticleDetailScreen(
                article: article,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenSize.height * 0.22,
              width: double.infinity,
              child: Hero(
                tag: 'article-photo-tag-${article.id}',
                child: CachedNetworkImage(
                  imageUrl: article.photo,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 400),
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: CustomText(
                    article.title,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: CustomText(
                    DateFormatter.formatDate(article.created_at),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: CustomText(
                article.description,
                fontSize: 15,
                maxLines: 3,
                textOverflow: TextOverflow.ellipsis,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
