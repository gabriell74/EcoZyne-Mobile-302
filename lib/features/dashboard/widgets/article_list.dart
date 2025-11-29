import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/models/article.dart';
import 'package:ecozyne_mobile/features/articles/screens/article_detail_screen.dart';
import 'package:flutter/material.dart';

class ArticleList extends StatelessWidget {
  final List<Article> articles;

  const ArticleList({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (articles.isEmpty)
          SizedBox(
            height: 215,
            child: const Center(
              child: LoadingWidget(height: 215, width: 100),
            ),
          )
        else
          SizedBox(
            height: 215,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final Article article = articles[index];

                return Container(
                  width: 250,
                  margin: const EdgeInsets.only(left: 6),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ArticleDetailScreen(
                            article: article,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 130,
                            width: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: article.photo,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: LoadingWidget(width: 60,),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                            child: CustomText(
                              article.title,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0, left: 10.0),
                            child: CustomText(
                              article.description,
                              color: Colors.grey,
                              fontSize: 12,
                              maxLines: 2,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}