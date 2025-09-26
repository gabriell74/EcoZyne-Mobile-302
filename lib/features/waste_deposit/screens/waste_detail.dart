import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';

class WasteDetailScreen extends StatelessWidget {
  const WasteDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: _screenSize.height * 0.53,
                    width: double.infinity,
                    color: Colors.lightGreen,
                  ),
                  BackButton(),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      "Kategori Sampah",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    const CustomText(
                      "sisa sayur, kulit buah, dedaunan",
                      fontSize: 14,
                      color: Color.fromARGB(255, 88, 88, 88),
                    ),
                    const SizedBox(height: 20),
                    const CustomText(
                      "Klasifikasi",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 8),
                    const CustomText(
                      "Sampah yang diterima hanya yang termasuk ke dalam kategori sampah yaitu sisa sayur, kulit buah dan dedaunan.",
                      fontSize: 14,
                      color: Color.fromARGB(255, 88, 88, 88),
                    ),
                    const Divider(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        CustomText("Berat Sampah", fontWeight: FontWeight.w500),
                        CustomText("1 Kg"),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        CustomText("Poin", fontWeight: FontWeight.w500),
                        CustomText("10 Poin"),
                      ],
                    ),
                    SizedBox(height: _screenSize.height * 0.08),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const CustomText(
                          "Setor Sampah",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
