import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/features/comic/widgets/comic_card.dart';
import 'package:flutter/material.dart';

class ComicScreen extends StatelessWidget {
  const ComicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> comics = [
      {
        'title': 'Eco Buster',
        'image': 'assets/images/cover1.png',
        'comicImages': [
          'assets/images/cover1.png',
          'assets/images/cover2.png',
          'assets/images/cover3.png',
        ],
      },
      {
        'title': 'Mico dan Lobak',
        'image': 'assets/images/cover1.png',
        'comicImages': [
          'assets/images/activity2.png',
          'assets/images/activity.png',
        ],
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Komik'),
        centerTitle: true,
        backgroundColor: const Color(0xFF55C173),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: AppBackground(
        child: ListView.builder(
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
                      imagePaths: List<String>.from(
                        comic['comicImages'] as List<dynamic>,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ComicDetailScreen extends StatelessWidget {
  final String title;
  final List<String> imagePaths;

  const ComicDetailScreen({
    super.key,
    required this.title,
    required this.imagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: const Color(0xFF55C173),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: imagePaths
              .map(
                (path) => Image.asset(
                  path,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
