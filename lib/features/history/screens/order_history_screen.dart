import 'package:flutter/material.dart';
import '../widgets/history_item.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Dummy data sementara
  final List<Map<String, dynamic>> dummyData = [
    {
      "label": "KEMARIN",
      "items": [
        HistoryItem(
          icon: Icons.shopping_bag_outlined,
          color: Color.fromARGB(255, 152, 85, 193),
          title: "Pembelian Berhasil",
          subtitle: "Pupuk, 12, COD\n900.000",
          time: "1d",
        ),
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyData.length,
      itemBuilder: (context, index) {
        final group = dummyData[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group["label"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            ...group["items"],

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
