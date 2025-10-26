import 'package:flutter/material.dart';
import '../widgets/history_item.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text(
          "KEMARIN",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        HistoryItem(
          icon: Icons.shopping_bag_outlined,
          color: Color.fromARGB(255, 152, 85, 193),
          title: "Pembelian Berhasil",
          subtitle: "Pupuk, 12, COD\n900.000",
          time: "1d",
        ),
      ],
    );
  }
}
