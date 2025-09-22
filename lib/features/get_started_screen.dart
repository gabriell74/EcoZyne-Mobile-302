import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/get_started.mp4")
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        _controller.setVolume(0);
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _controller.value.isInitialized
              ? FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          )
              : Container(color: Colors.white),

          Padding(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.22,
                      child: Image.asset(
                        'assets/images/logo.png',
                        color: Colors.white,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const CustomText(
                      'Selamat Datang!',
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 15),
                    const CustomText(
                      'Ayo Jadi Bagian Dari Komunitas',
                      color: Colors.white,
                    ),
                    SizedBox(height: screenSize.height * 0.23)
                  ],
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    foregroundColor: Theme.of(context).primaryColor,
                    shape: const StadiumBorder(),
                  ),
                  child: const CustomText(
                    "Mulai",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
