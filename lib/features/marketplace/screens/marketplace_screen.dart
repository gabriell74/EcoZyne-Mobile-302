import 'package:flutter/material.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text(
          'Katalog Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // Body (tanpa bottom navigation)
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.close),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Grid Produk
            Expanded(
              child: GridView.builder(
                itemCount: 4, // Data hardcode
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final List<Map<String, String>> products = [
                    {
                      'image': 'assets/images/cover1.png',
                      'name': 'Pupuk Kompos',
                      'price': 'Rp 10.000',
                    },
                    {
                      'image': 'assets/images/cover2.png',
                      'name': 'Bibit Cabai',
                      'price': 'Rp 15.000',
                    },
                    {
                      'image': 'assets/images/cover3.png',
                      'name': 'Tanah Subur',
                      'price': 'Rp 12.000',
                    },
                    {
                      'image': 'assets/images/cover1.png',
                      'name': 'Pupuk Cair',
                      'price': 'Rp 20.000',
                    },
                  ];

                  final item = products[index];

                  return Card(
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Gambar
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.asset(
                              item['image']!,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Nama Produk
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              item['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Harga
                          Text(
                            item['price']!,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),

                          const Spacer(),

                          // Tombol tambah
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFF55C173),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
