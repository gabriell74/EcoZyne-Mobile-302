import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomText(
              "Apa Itu Eco Enzyme?",
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
              "Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme"
                  "Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme"
                  "Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme Eco Enzyme",
              fontSize: 15,
              textOverflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
