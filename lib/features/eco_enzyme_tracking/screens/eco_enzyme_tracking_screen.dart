import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/features/eco_enzyme_tracking/widgets/tracking_card.dart';
import 'package:ecozyne_mobile/data/models/eco_enzyme_tracking.dart';
import 'package:ecozyne_mobile/data/providers/eco_enzyme_tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EcoEnzymeTrackingScreen extends StatefulWidget {
  const EcoEnzymeTrackingScreen({super.key});

  @override
  State<EcoEnzymeTrackingScreen> createState() => _EcoEnzymeTrackingScreenState();
}

class _EcoEnzymeTrackingScreenState extends State<EcoEnzymeTrackingScreen> {
  double _calculateProgress(DateTime start, DateTime end) {
    final total = end.difference(start).inDays;
    final elapsed = DateTime.now().difference(start).inDays;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EcoEnzymeTrackingProvider>().getEcoEnzymeTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Pembuatan Eco Enzyme"),
        centerTitle: true,
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<EcoEnzymeTrackingProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: LoadingWidget());
              }

              if (provider.batchTracking.isEmpty) {
                return Center(
                  child: EmptyState(
                    connected: provider.connected,
                    message: provider.message,
                  ),
                );
              }

              return ListView.builder(
                itemCount: provider.batchTracking.length,
                itemBuilder: (context, index) {
                  final EcoEnzymeTracking batch = provider.batchTracking[index];

                  final progress = _calculateProgress(batch.startDate, batch.dueDate);

                  return TrackingCard(
                    enzyme: {
                      "name": batch.batchName,
                      "startDate": batch.startDate,
                      "dueDate": batch.dueDate,
                      "notes": batch.notes,
                    },
                    progress: progress,
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/eco-enzyme-tracking-form');
        },
        backgroundColor: const Color(0xFF55C173),
        child: const Icon(Icons.add),
      ),
    );
  }
}
