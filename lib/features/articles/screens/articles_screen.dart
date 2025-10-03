import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: CustomText("Artikel", fontWeight: FontWeight.bold, fontSize: 24),
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SearchArticle(),

              const SizedBox(height: 11),

              Expanded(
                child: Consumer<ArticleProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.articles.isEmpty) {
                      return Center(child: Text(provider.message));
                    }

                    return ListView.builder(
                      itemCount: provider.articles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: ArticleCard(article: provider.articles[index]),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
