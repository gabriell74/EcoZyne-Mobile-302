import 'package:ecozyne_mobile/features/comic/widgets/comic_card.dart';
import 'package:flutter/material.dart';

class ComicScreen extends StatelessWidget {
  const ComicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> comics = [
      {
        'title': 'Eco Buster',
        'image': 'assets/images/cover1.png',
        'comicImage': 'assets/images/cover1.png',
      },
      {
        'title': 'Mico dan Lobak',
        'image': 'assets/images/cover1.png',
        'comicImage': 'assets/images/cover1.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Komik'),
        centerTitle: true,
        backgroundColor: Color(0xFF55C173),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: comics.length,
        itemBuilder: (context, index) {
          final comic = comics[index];
          return ComicCard(
            title: comic['title']!,
            imagePath: comic['image']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ComicDetailScreen(
                    title: comic['title']!,
                    imagePath: comic['comicImage']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ComicDetailScreen extends StatelessWidget {
  final String title;
  final String imagePath;

  const ComicDetailScreen({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xFF55C173),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ClipRRect(child: Image.asset(imagePath, fit: BoxFit.contain)),
      ),
    );
  }
}
