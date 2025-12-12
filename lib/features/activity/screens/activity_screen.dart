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
import 'package:ecozyne_mobile/features/activity/widget/activity_registration_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

enum ActivityFilter { kegiatan, riwayat, pendaftaran }

class ActivityScreen extends StatefulWidget {
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  ActivityFilter selectedFilter = ActivityFilter.kegiatan;
  String _query = "";

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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Kegiatan"),
        centerTitle: true,
      ),
      body: AppBackground(
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            final provider = context.read<ActivityProvider>();

            switch (selectedFilter) {
              case ActivityFilter.kegiatan:
                return provider.getActivity();
              case ActivityFilter.riwayat:
                return provider.getCompletedActivity();
              case ActivityFilter.pendaftaran:
                return provider.getActivityRegistrations();
            }
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
                child:  Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: SearchActivity(
                    onSearch: (query) {
                      setState(() => _query = query);
                    },
                  ),
                ),
              )
            ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            return const Center(child: LoadingWidget(height: 80));
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

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFilterButton(
                              label: "Kegiatan Sosial",
                              active: selectedFilter == ActivityFilter.kegiatan,
                              onTap: () async {
                                final provider = context.read<ActivityProvider>();
                                setState(() => selectedFilter = ActivityFilter.kegiatan);
                                if (provider.activities.isEmpty){
                                  await provider.getActivity();
                                }
                              },
                            ),
                            const SizedBox(width: 12),

                            _buildFilterButton(
                              label: "Riwayat Pendaftaran",
                              active: selectedFilter == ActivityFilter.pendaftaran,
                              onTap: () async {
                                final provider = context.read<ActivityProvider>();
                                setState(() => selectedFilter = ActivityFilter.pendaftaran);

                                  await provider.getActivityRegistrations();
                              },
                            ),
                            const SizedBox(width: 12),
                            _buildFilterButton(
                              label: "Riwayat Kegiatan Sosial",
                              active: selectedFilter == ActivityFilter.riwayat,
                              onTap: () async {
                                final provider = context.read<ActivityProvider>();
                                setState(() => selectedFilter = ActivityFilter.riwayat);

                                if (provider.completedActivities.isEmpty) {
                                  await provider.getCompletedActivity();
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              Consumer<ActivityProvider>(
                builder: (context, provider, child) {
                  if (selectedFilter == ActivityFilter.kegiatan) {
                    return _buildKegiatanSection(provider);
                  }

                  if (selectedFilter == ActivityFilter.riwayat) {
                    return _buildRiwayatSection(provider);
                  }

                  return _buildActivityRegistrationSection(provider);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKegiatanSection(ActivityProvider provider) {
    final activities = provider.activities;

    final filtered = _query.isEmpty
        ? activities
        : activities
        .where((a) => a.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    if (provider.isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          children: [
            Center(child: LoadingWidget()),
            SizedBox(height: 50),
          ],
        ),
      );
    }

    if (activities.isEmpty && _query.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyState(connected: provider.connected, message: provider.message),
            const SizedBox(height: 50),
          ],
        ),
      );
    }

    if (_query.isNotEmpty && filtered.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: EmptyState(connected: true, message: "Kegiatan tidak ditemukan."),
        ),
      );
    }

    return SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 5,
      crossAxisSpacing: 2,
      childCount: filtered.length,
      itemBuilder: (context, index) {
        final activity = filtered[index];

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
  }

  Widget _buildRiwayatSection(ActivityProvider provider) {
    if (provider.isCompletedLoading) {
      return const SliverToBoxAdapter(child: Center(child: LoadingWidget()));
    }

    if (provider.completedActivities.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyState(
              connected: provider.connected,
              message: provider.completedMessage,
            ),
            const SizedBox(height: 50),
          ],
        ),
      );
    }


    return SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 5,
      crossAxisSpacing: 2,
      childCount: provider.completedActivities.length,
      itemBuilder: (context, index) {
        final activity = provider.completedActivities[index];
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
  }

  Widget _buildFilterButton({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF55C173) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: active ? const Color(0xFF55C173) : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: active
              ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityRegistrationSection(ActivityProvider provider) {
    if (provider.isRegistrationLoading) {
      return const SliverToBoxAdapter(child: Center(child: LoadingWidget()));
    }

    if (provider.activityRegistrations.isEmpty) {
      return SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyState(
              connected: provider.connected,
              message: provider.registrationMessage,
            ),
            const SizedBox(height: 50),
          ],
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final item = provider.activityRegistrations[index];
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: ActivityRegistrationCard(registration: item),
          );
        },
        childCount: provider.activityRegistrations.length,
      ),
    );
  }
}