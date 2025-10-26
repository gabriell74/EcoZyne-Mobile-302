import 'package:flutter/material.dart';
import '../widgets/history_item.dart';

class PointInScreen extends StatelessWidget {
  const PointInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text("HARI INI", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        HistoryItem(
          icon: Icons.check_circle_outline,
          color: Color(0xFF55C173),
          title: "Tambah Poin Berhasil",
          subtitle: "+1000 Poin",
          time: "3j",
        ),
        SizedBox(height: 16),
        Text("KEMARIN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        HistoryItem(
          icon: Icons.check_circle_outline,
          color: Color(0xFF55C173),
          title: "Tambah Poin Berhasil",
          subtitle: "+2000 Poin",
        ),
      ],
    );
  }
}
