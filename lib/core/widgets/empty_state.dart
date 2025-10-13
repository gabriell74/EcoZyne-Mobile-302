import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyState extends StatelessWidget {
  final bool connected;
  final String message;
  const EmptyState({super.key, required this.connected, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          connected
          ? 'assets/videos/empty_data.json'
          : 'assets/videos/no_internet.json',
          height: 200,
        ),
        const SizedBox(height: 10,),
        CustomText(
          message,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
