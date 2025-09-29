import 'package:flutter/material.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        // Header Artikel + See All
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Artikel",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Arahkan ke halaman semua artikel
                },
                child: const Text("See All"),
              ),
            ],
          ),
        ),

        // List artikel horizontal
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildArticleCard("eco-enzyme", Colors.green),
              _buildArticleCard("eco-enzyme", Colors.orange),
              _buildArticleCard("eco-enzyme", Colors.blue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArticleCard(String title, Color color) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // gambar placeholder pakai warna
            Container(height: 100, width: double.infinity, color: color),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
