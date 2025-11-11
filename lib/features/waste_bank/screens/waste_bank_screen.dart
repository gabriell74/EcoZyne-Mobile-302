import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/slide_fade_in.dart';
import 'package:ecozyne_mobile/features/waste_bank/screens/waste_bank_register_screen.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/waste_bank_search.dart';
import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/waste_bank_card.dart';

class WasteBankScreen extends StatelessWidget {
  const WasteBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Bank Sampah"),
        centerTitle: true,
      ),
      body: AppBackground(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SearchWasteBank(),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const WasteBankRegisterScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB9F5C6),
                      ),
                      child: const CustomText(
                        "Daftar sebagai bank sampah",
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 1),
                  ],
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 5.0,
                  ),
                  child: SlideFadeIn(
                    delayMilliseconds: index * 100,
                    child: WasteBankCard(),
                  ),
                );
              }, childCount: 10),
            ),
          ],
        ),
      ),
    );
  }
}
