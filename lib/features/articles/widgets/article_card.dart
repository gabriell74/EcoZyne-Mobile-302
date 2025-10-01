import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/article.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomText(
                article.title,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: screenSize.height * 0.22,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/cover1.png"),
                  fit: BoxFit.cover
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomText(
                article.description,
                fontSize: 15,
                textOverflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
