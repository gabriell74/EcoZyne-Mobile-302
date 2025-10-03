import 'package:flutter/material.dart';

class FilterActivity extends StatefulWidget {
  const FilterActivity({super.key});

  @override
  State<FilterActivity> createState() => _FilterActivityState();
}

class _FilterActivityState extends State<FilterActivity> {
  String selectedFilter = "semua";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedFilter = "semua";
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedFilter == "semua"
                ? const Color(0xFF649B71)
                : Colors.white,
            foregroundColor: Colors.black
          ),
          child: const Text("Semua"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedFilter = "on going";
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedFilter == "on going"
                ? const Color(0xFF649B71)
                : Colors.white,
              foregroundColor: Colors.black
          ),
          child: const Text("On Going"),
        ),
      ],
    );
  }
}
