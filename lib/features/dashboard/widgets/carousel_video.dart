import 'package:ecozyne_mobile/features/dashboard/screens/video_player_screen.dart';
import 'package:flutter/material.dart';

class CarouselVideo extends StatefulWidget {
  const CarouselVideo({super.key});

  @override
  State<CarouselVideo> createState() => _CarouselVideoState();
}

class _CarouselVideoState extends State<CarouselVideo> {
  late PageController _controller;
  int _currentPage = 0;

  final List<Map<String, String>> _items = [
    {
      "image": "assets/images/cover1.png",
      "video": "assets/videos/eco_enzyme_1.mp4",
    },
    {
      "image": "assets/images/cover2.png",
      "video": "assets/videos/eco_enzyme_2.mp4",
    },
    {
      "image": "assets/images/cover3.png",
      "video": "assets/videos/eco_enzyme_3.mp4",
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0, viewportFraction: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.sizeOf(context);
    return Column(
      children: [
        SizedBox(
          height: _screenSize.height * 0.25,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerScreen(
                        videoPath: item["video"]!,
                        title: "Video ${index + 1}", description: 'video ini menjelaskan',
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(item["image"]!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _items.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 10 : 6,
              height: _currentPage == index ? 10 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFF55C173)
                    : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
 