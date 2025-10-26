import 'package:flutter/material.dart';
import '../widgets/history_item.dart';

class PointOutScreen extends StatelessWidget {
  const PointOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text("HARI INI", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        HistoryItem(
          icon: Icons.arrow_circle_up_outlined,
          color: Color(0xFF738FFF),
          title: "Penukaran Poin Berhasil",
          subtitle: "-1000 Poin",
          time: "3j",
        ),
        SizedBox(height: 16),
        Text("KEMARIN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        HistoryItem(
          icon: Icons.arrow_circle_up_outlined,
          color: Color(0xFF738FFF),
          title: "Penukaran Poin Berhasil",
          subtitle: "-2000 Poin",
        ),
      ],
    );
  }
}
