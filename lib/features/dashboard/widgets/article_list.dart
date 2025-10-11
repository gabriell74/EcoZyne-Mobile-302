import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/article.dart';
import 'package:ecozyne_mobile/data/providers/article_provider.dart';
import 'package:ecozyne_mobile/features/articles/screens/article_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({super.key});

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArticleProvider>().fetchLatestArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                "Artikel",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/articles");
                },
                child: const CustomText("Lihat Semua", color: Colors.blueGrey),
              ),
            ],
          ),
        ),

        Consumer<ArticleProvider>(
          builder: (context, provider, child) {
            return SizedBox(
              height: 215,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.latestArticles.length,
                itemBuilder: (context, index) {
                  final Article article = provider.latestArticles[index];

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
                            Container(
                              height: 130,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                imageUrl: article.photo,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:8.0, left: 10.0),
                              child: CustomText(
                                article.title,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:4.0, left: 10.0),
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
            );
          },
        ),
      ],
    );
  }
}
