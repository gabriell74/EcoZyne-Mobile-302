import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/eco_enzyme_tracking/widgets/tracking_card.dart';
import 'package:flutter/material.dart';

class EcoEnzymeTrackingScreen extends StatefulWidget {
  const EcoEnzymeTrackingScreen({super.key});

  @override
  State<EcoEnzymeTrackingScreen> createState() => _EcoEnzymeTrackingScreenState();
}

class _EcoEnzymeTrackingScreenState extends State<EcoEnzymeTrackingScreen> {
  final List<Map<String, dynamic>> _ecoEnzymes = [
    {
      "name": "Eco Enzyme Kulit Jeruk",
      "startDate": DateTime(2025, 10, 1),
      "dueDate": DateTime(2026, 1, 1),
      "status": "In Progress",
    },
    {
      "name": "Eco Enzyme Sayur Busuk",
      "startDate": DateTime(2022, 8, 15),
      "dueDate": DateTime(2025, 10, 24),
      "status": "In Progress",
    },
  ];

  double _calculateProgress(DateTime start, DateTime end) {
    final total = end.difference(start).inDays;
    final elapsed = DateTime.now().difference(start).inDays;
    final double progress = (elapsed / total).clamp(0, 1);
    return progress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Pembuatan Eco Enzyme"),
        centerTitle: true,
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _ecoEnzymes.length,
            itemBuilder: (context, index) {
              final enzyme = _ecoEnzymes[index];
              final progress = _calculateProgress(
                enzyme['startDate'],
                enzyme['dueDate'],
              );
              return TrackingCard(enzyme: enzyme, progress: progress,);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         Navigator.pushNamed(context, '/eco-enzyme-tracking-form');
        },
        backgroundColor: Color(0xFF55C173),
        child: const Icon(Icons.add),
      ),
    );
  }
}
