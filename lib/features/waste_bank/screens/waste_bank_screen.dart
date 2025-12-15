import 'package:ecozyne_mobile/core/utils/user_helper.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/login_required_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/slide_fade_in.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_list_provider.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_submission_provider.dart';
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
    bool isWasteBank = context.watch<UserProvider>().user?.role == 'waste_bank';
    bool hasWasteBankSubmissions = context.watch<WasteBankSubmissionProvider>().hasPending;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Bank Sampah", fontWeight: FontWeight.bold, fontSize: 18),
        centerTitle: true,
      ),
      body: AppBackground(
        child: Consumer<WasteBankListProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LoadingWidget(),
                    const SizedBox(height: 16),
                    CustomText(
                      "Memuat...",
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator.adaptive(
              onRefresh: () async {
                await context.read<WasteBankListProvider>().getWasteBankList();
              },
              color: Colors.black,
              backgroundColor: const Color(0xFF55C173),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF55C173),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: Column(
                          children: [
                            const SearchWasteBank(),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.recycling_outlined,
                                      color: Color(0xFF55C173),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          "${provider.wasteBanks.length} Bank Sampah",
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        const SizedBox(height: 2),
                                        CustomText(
                                          "Terdaftar di aplikasi",
                                          color: Colors.white.withValues(alpha: 0.9),
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  if (!isWasteBank && !hasWasteBankSubmissions)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                        child: Material(
                          elevation: 2,
                          shadowColor: const Color(0xFF55C173).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {
                              final isLoggedIn = UserHelper.isLoggedIn(context);
                              if (!isLoggedIn) {
                                showDialog(
                                  context: context,
                                  builder: (context) => LoginRequiredDialog(),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (
                                        context) => const WasteBankRegisterScreen(),
                                  ),
                                );
                              }
                            },

                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFB9F5C6),
                                    Color(0xFF9AE8B0),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.add_business_rounded,
                                      color: Color(0xFF55C173),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const CustomText(
                                    "Daftar sebagai Bank Sampah",
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (provider.wasteBanks.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: EmptyState(
                          connected: provider.connected,
                          message: provider.message,
                        ),
                      ),
                    )
                  else ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                        child: CustomText(
                          "Daftar Bank Sampah",
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final wasteBank = provider.wasteBanks[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: SlideFadeIn(
                                delayMilliseconds: index * 100,
                                child: WasteBankCard(
                                  wasteBank: wasteBank,
                                ),
                              ),
                            );
                          },
                          childCount: provider.wasteBanks.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 30,))
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}