import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class WasteDeliveryTab extends StatelessWidget {
  final List<Map<String, dynamic>> wasteDeposit;

  const WasteDeliveryTab({super.key, required this.wasteDeposit});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: wasteDeposit.length,
      itemBuilder: (context, index) {
        final data = wasteDeposit[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        'Nama Pengguna',
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      Text(data['name']),
                      Text(data['email']),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(70, 30),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: const CustomText('Terima', color: Colors.white),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(70, 30),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: const CustomText('Tolak', color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}