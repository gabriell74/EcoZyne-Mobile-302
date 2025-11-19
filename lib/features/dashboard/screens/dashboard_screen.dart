import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/activity_provider.dart';
import 'package:ecozyne_mobile/data/providers/article_provider.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/article_list.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/empty_latest_activity.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/greeting_card.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/carousel_video.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/category_menu.dart';
import 'package:ecozyne_mobile/features/dashboard/widgets/latest_activity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activityProvider = context.read<ActivityProvider>();
      final articleProvider = context.read<ArticleProvider>();

      activityProvider.getLatestActivity();
      articleProvider.fetchLatestArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = context.watch<ActivityProvider>();
    final articleProvider = context.watch<ArticleProvider>();

    final latestActivity = activityProvider.latestActivity;
    final latestArticles = articleProvider.latestArticles;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          activityProvider.getLatestActivity(),
          articleProvider.fetchLatestArticles(),
        ]);
      },
      color: Colors.black,
      backgroundColor: const Color(0xFF55C173),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 5),
              const GreetingCard(),
              const CarouselVideo(),
              const SizedBox(height: 15),
              const CustomText(
                "Menu Navigasi",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 15),
              const CategoryMenu(),
              const Divider(),
              const SizedBox(height: 10),

              const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "Kegiatan Terbaru",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 9,
              ),

              if (!activityProvider.connected)
                const EmptyState(
                  connected: false,
                  message: "Tidak ada koneksi internet",
                )
              else if (latestActivity == null)
                const EmptyLatestActivity()
              else
                LatestActivity(activity: latestActivity),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      "Artikel",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/articles");
                      },
                      child: const CustomText("Lihat Semua", color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),

              if (articleProvider.isLoading)
                const Center(child: LoadingWidget())
              else if (latestArticles.isEmpty)
                const EmptyState(
                  connected: true,
                  message: "Belum ada artikel tersedia",
                )
              else
                ArticleList(articles: latestArticles),
            ],
          ),
        ),
      ),
    );
  }
}