import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/slide_fade_in.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_list_provider.dart';
import 'package:ecozyne_mobile/features/waste_bank/screens/waste_bank_register_screen.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/waste_bank_search.dart';
import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/waste_bank_card.dart';
import 'package:provider/provider.dart';

class WasteBankScreen extends StatefulWidget {
  const WasteBankScreen({super.key});

  @override
  State<WasteBankScreen> createState() => _WasteBankScreenState();
}

class _WasteBankScreenState extends State<WasteBankScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WasteBankListProvider>().getWasteBankList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Bank Sampah"),
        centerTitle: true,
      ),
      body: AppBackground(
        child: Consumer<WasteBankListProvider>(
          builder: (context, provider, _) {
            // === LOADING STATE ===
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // === ERROR STATE ===
            if (!provider.connected) {
              return const Center(
                child: CustomText(
                  "Tidak ada koneksi",
                  color: Colors.red,
                ),
              );
            }

            // === DATA KOSONG ===
            if (provider.wasteBanks.isEmpty) {
              return const Center(
                child: CustomText("Belum ada bank sampah terdaftar."),
              );
            }

            // === LIST DATA ===
            return CustomScrollView(
              slivers: [
                // ===== SEARCH + BUTTON =====
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SearchWasteBank(),
                        const SizedBox(height: 30),

                        // REGISTER BUTTON
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

                // ===== LIST ITEM =====
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final data = provider.wasteBanks[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 5.0,
                        ),
                        child: SlideFadeIn(
                          delayMilliseconds: index * 100,
                          child: WasteBankCard(
                            wasteBank: data, // <-- tinggal isi constructor
                          ),
                        ),
                      );
                    },
                    childCount: provider.wasteBanks.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
