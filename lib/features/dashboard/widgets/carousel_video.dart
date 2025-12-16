import 'dart:async';
import 'package:ecozyne_mobile/features/dashboard/screens/video_player_screen.dart';
import 'package:flutter/material.dart';

class CarouselVideo extends StatefulWidget {
  const CarouselVideo({super.key});

  @override
  State<CarouselVideo> createState() => _CarouselVideoState();
}

class _CarouselVideoState extends State<CarouselVideo> {
  late PageController _controller;
  late Timer _timer;
  int _currentPage = 0;

  final List<Map<String, String>> _items = [
    {
      "image": "assets/images/cover1.png",
      "video": "assets/videos/eco_enzyme_1.mp4",
      "title": "Apa itu Eco Enzyme?",
      "appBarTitle": "Eco Enzyme",
      "description":
      "Kalian pernah dengar eco enzyme? Atau masih penasaran sebenarnya apa sih eco enzyme itu? Di video ini kamu bakal diajak kenalan mulai dari apa itu eco enzyme, bagaimana proses fermentasinya terbentuk, sampai alasan kenapa cairan alami ini makin banyak digunakan. Yuk kenalan lebih dekat dengan eco enzyme!",
    },
    {
      "image": "assets/images/cover3.png",
      "video": "assets/videos/eco_enzyme_2.mp4",
      "title": "Manfaat Eco Enzyme",
      "appBarTitle": "Eco Enzyme",
      "description":
      "Eco enzyme itu ternyata bukan cuma cairan biasa, lho! Di video ini kamu akan melihat berbagai manfaat dan penggunaan eco enzyme di kehidupan sehari-hari, mulai dari bersih-bersih rumah, merawat tanaman, sampai membantu mengurangi limbah. Praktis, bermanfaat, dan mudah dipakai di rumah. Ayo cari tahu selengkapnya di video ini!",
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_controller.hasClients) return;

      int nextPage = _currentPage + 1;
      if (nextPage >= _items.length) {
        nextPage = 0;
      }

      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Column(
      children: [
        SizedBox(
          height: screenSize.height * 0.25,
          child: PageView.builder(
            controller: _controller,
            itemCount: _items.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final item = _items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerScreen(
                        videoPath: item["video"]!,
                        title: item["title"]!,
                        appBarTitle: item["appBarTitle"]!,
                        description: item["description"]!,
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
