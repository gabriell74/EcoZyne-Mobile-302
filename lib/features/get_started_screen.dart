import 'package:ecozyne_mobile/core/widgets/animated_gradient_text.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/floating_logo.dart';
import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 100,
                child: FloatingLogo(),
              ),
              const SizedBox(height: 15),
              const CustomText(
                'Selamat Datang di',
                color: Color(0xFF55C173),
                fontSize: 34.0,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              const AnimatedGradientText(
                "Ecozyne",
                colors: [Colors.green, Colors.blue],
                style: TextStyle(
                  fontSize: 34.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  shadowColor: Colors.black45,
                  elevation: 5,
                ),
                child: const CustomText(
                  "Mulai Sekarang",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    'Bersama kita bisa membuat bumi lebih hijau ',
                    fontSize: 14,
                    textAlign: TextAlign.center,
                  ),
                  Icon(Icons.eco, color: Color(0xFF55C173)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
