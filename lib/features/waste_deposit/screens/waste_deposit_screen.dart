import 'package:flutter/material.dart';

class WasteDepositScreen extends StatelessWidget {
  const WasteDepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Ada 2 tab: Saat ini & Terima
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Setoran Sampah',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Saat ini'),
              Tab(text: 'Terima'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Tab 1: Saat ini
            SaatIniTab(),

            // Tab 2: Terima
            TerimaTab(),
          ],
        ),
      ),
    );
  }
}

class SaatIniTab extends StatelessWidget {
  const SaatIniTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return const UserCard();
      },
    );
  }
}

class TerimaTab extends StatelessWidget {
  const TerimaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Belum ada setoran diterima'),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const Text('Nama Pengguna', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Nama asli'),
                  const Text('Email'),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(70, 30),
                padding: EdgeInsets.zero,
              ),
              onPressed: () {},
              child: const Text('Terima', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
