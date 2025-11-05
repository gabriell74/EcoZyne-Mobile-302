import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/slide_fade_in.dart';
import 'package:ecozyne_mobile/data/providers/article_provider.dart';
import 'package:ecozyne_mobile/features/articles/widgets/article_card.dart';
import 'package:ecozyne_mobile/features/articles/widgets/search_article.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  String _query = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArticleProvider>().fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Artikel"),
        centerTitle: true,
      ),
      body: AppBackground(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: SearchArticle(
                  onSearch: (query) {
                    setState(() {
                      _query = query;
                    });
                  },
                ),
              ),
            ),
        
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: const Color(0xFF55C173),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: CustomText(
                            "Punya pertanyaan seputar Eco Enzyme?",
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF55C173),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/discussion-forum',
                            );
                          },
                          child: const Text("Gabung Diskusi Komunitas"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 8),
                child: CustomText(
                  "Jelajahi Artikel",
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
        
            Consumer<ArticleProvider>(
              builder: (context, provider, child) {
                final articles = provider.articles;
        
                final filtered = _query.isEmpty
                    ? articles
                    : articles
                          .where(
                            (article) =>
                                article.title.toLowerCase().contains(
                                  _query.toLowerCase(),
                                ) ||
                                article.description.toLowerCase().contains(
                                  _query.toLowerCase(),
                                ),
                          )
                          .toList();
        
                if (provider.isLoading) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: LoadingWidget()),
                  );
                }
        
                if (!provider.connected || articles.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: EmptyState(
                        connected: provider.connected,
                        message: provider.message,
                      ),
                    ),
                  );
                }
        
                if (filtered.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: EmptyState(
                        connected: true,
                        message: "Artikel tidak ditemukan.",
                      ),
                    ),
                  );
                }
        
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final article = filtered[index];
                    return Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: SlideFadeIn(
                        delayMilliseconds: index * 100,
                        child: ArticleCard(article: article)
                      ),
                    );
                  }, childCount: filtered.length),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
