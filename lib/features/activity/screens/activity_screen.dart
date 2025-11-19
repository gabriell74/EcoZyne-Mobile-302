import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/slide_fade_in.dart';
import 'package:ecozyne_mobile/data/providers/activity_provider.dart';
import 'package:ecozyne_mobile/features/activity/widget/activity_card.dart';
import 'package:ecozyne_mobile/features/activity/widget/activity_header.dart';
import 'package:ecozyne_mobile/features/activity/widget/empty_favorite_activity.dart';
import 'package:ecozyne_mobile/features/activity/widget/favorite_activity.dart';
import 'package:ecozyne_mobile/features/activity/widget/search_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool selectedFilter = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityProvider>().getActivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Kegiatan"),
        centerTitle: true,
      ),
      body: AppBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            if (selectedFilter) {
              return await context.read<ActivityProvider>().getActivity();
            } else {
              return await context.read<ActivityProvider>().getCompletedActivity();
            }
          },
          color: Colors.black,
          backgroundColor: const Color(0xFF55C173),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SearchActivity(),
                      const SizedBox(height: 30),
                      const ActivityHeader(),
                      const SizedBox(height: 25),
                      const CustomText(
                        "Kegiatan Unggulan",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      const SizedBox(height: 11),

                      Consumer<ActivityProvider>(
                        builder: (context, provider, child) {
                          final featured = provider.getFeaturedActivity();
                          if (provider.isLoading) {
                            return const Center(child: LoadingWidget(height: 80,));
                          }
                          if (provider.activities.isEmpty || featured == null) {
                            return const EmptyFavoriteActivity();
                          }
                          return FavoriteActivity(activity: featured);
                        },
                      ),

                      const SizedBox(height: 30),
                      const CustomText(
                        "Jelajahi Kegiatan",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 11),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedFilter = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedFilter ? const Color(0xFF55C173) : Colors.white,
                              foregroundColor: Colors.black
                            ),
                            child: const Text("Kegiatan Sosial"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              final provider = context.read<ActivityProvider>();
                              setState(() {
                                selectedFilter = false;
                              });
                              if (provider.completedActivities.isEmpty) {
                                await provider.getCompletedActivity();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !selectedFilter ? const Color(0xFF55C173) : Colors.white,
                              foregroundColor: Colors.black
                            ),
                            child: const Text("Riwayat Kegiatan Sosial"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              Consumer<ActivityProvider>(
                builder: (context, provider, child) {
                  final bool shouldShowLoading = selectedFilter
                      ? provider.isLoading
                      : provider.isCompletedLoading;
                  final bool showEmptyState = selectedFilter
                      ? provider.activities.isEmpty
                      : provider.completedActivities.isEmpty;
                  if (shouldShowLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(child: LoadingWidget()),
                    );
                  }
                  if (showEmptyState) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Center(child: EmptyState(connected: provider.connected, message: provider.message)),
                          const SizedBox(height: 50),
                        ],
                      ));
                  }

                  return SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 2,
                    childCount: selectedFilter
                        ? provider.activities.length
                        : provider.completedActivities.length,
                    itemBuilder: (context, index) {
                      final activity = selectedFilter
                          ? provider.activities[index]
                          : provider.completedActivities[index];
                      return Column(
                        children: [
                          SlideFadeIn(
                            delayMilliseconds: index + 200,
                            child: ActivityCard(activity: activity),
                          ),
                          const SizedBox(height: 15),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

