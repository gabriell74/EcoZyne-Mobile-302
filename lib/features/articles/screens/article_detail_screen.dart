import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/article.dart';
import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({
    super.key,
    required this.article
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 260,
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              title: const CustomText(
                'Artikel',
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
              ),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildHeroImage(),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black12,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ),

            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomText(
                              article.title,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          CustomText(
                            DateFormatter.formatDate(article.created_at),
                              fontSize: 12,
                              color: Colors.grey[600],
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      const CustomText(
                        'Deskripsi',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                      ),

                      const SizedBox(height: 8),

                      CustomText(
                        article.description,
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.grey[800],
                      ),

                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Hero(
        tag: 'article-photo-tag-${article.id}',
        child: CachedNetworkImage(
          imageUrl: article.photo,
          fit: BoxFit.contain,
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
    );
  }
}
