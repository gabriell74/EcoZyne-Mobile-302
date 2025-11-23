import 'package:flutter/material.dart';
import '../widgets/history_item.dart';

class PointInScreen extends StatefulWidget {
  const PointInScreen({super.key});

  @override
  State<PointInScreen> createState() => _PointInScreenState();
}

class _PointInScreenState extends State<PointInScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  // Dummy data sementara (karena belum ada provider & service)
  final List<Map<String, dynamic>> dummyData = [
    {
      "label": "HARI INI",
      "items": [
        HistoryItem(
          icon: Icons.check_circle_outline,
          color: Color(0xFF55C173),
          title: "Tambah Poin Berhasil",
          subtitle: "+1000 Poin",
          time: "3j",
        ),
      ],
    },
    {
      "label": "KEMARIN",
      "items": [
        HistoryItem(
          icon: Icons.check_circle_outline,
          color: Color(0xFF55C173),
          title: "Tambah Poin Berhasil",
          subtitle: "+2000 Poin",
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
