import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  const LoadingWidget({super.key, this.width = 200, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Lottie.asset(
          'assets/videos/app_loading.json',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
