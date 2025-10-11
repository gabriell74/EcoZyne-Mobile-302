import 'package:flutter/material.dart';

class CarouselVideo extends StatefulWidget {
  const CarouselVideo({super.key});

  @override
  State<CarouselVideo> createState() => _CarouselVideoState();
}

class _CarouselVideoState extends State<CarouselVideo> {
  late PageController _controller;

  int _currentPage = 0;

  final List<String> _images = [
    "assets/images/cover1.png",
    "assets/images/cover2.png",
    "assets/images/cover3.png",
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: 1000,
      viewportFraction: 1,
    );
    _currentPage = 1000 % _images.length;
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
              setState(() {
                _currentPage = index % _images.length;
              });
            },
            itemBuilder: (context, index) {
              final imagePath = _images[index % _images.length];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
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
            _images.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 8 : 6,
              height: _currentPage == index ? 8 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index ? Color(0xFF55C173) : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        )

      ],
    );
  }
}
