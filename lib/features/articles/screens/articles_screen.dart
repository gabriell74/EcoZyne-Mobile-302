import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
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
      body: AppBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 100,
              backgroundColor: const Color(0xFF55C173),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                title: const CustomText(
                  "Artikel",
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                ),
                centerTitle: true,
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF55C173), Color(0xFF2EB67D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(13.0),
                child: SearchArticle(),
              ),
            ),

            Consumer<ArticleProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: LoadingWidget(),
                    ),
                  );
                }

                if (provider.articles.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(provider.message),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final article = provider.articles[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 12.0),
                        child: ArticleCard(article: article),
                      );
                    },
                    childCount: provider.articles.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
