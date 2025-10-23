import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Produk", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Hero(
                      tag: 'product-photo-tag-/* product.id */',
                      child: CachedNetworkImage(
                        imageUrl: 'https://example.com/invalid.jpg',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: LoadingWidget(width: 100,),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: Icon(Icons.broken_image,
                                color: Colors.grey, size: 50),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CustomText(
                      "Rp 25.000",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.local_shipping_outlined,
                            color: Color(0xFF55C173),
                            size: 28,
                          ),
                          title: CustomText(
                            "Cash on Delivery",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          subtitle: CustomText(
                            "Pembayaran langsung saat barang diterima",
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.recycling_outlined,
                            color: Color(0xFF55C173),
                            size: 28,
                          ),
                          title: CustomText(
                            "Bank Sampah Eco",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CustomText(
                      "Deskripsi Produk",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CustomText(
                      "Produk ini terbuat dari bahan ramah lingkungan dan "
                          "berkualitas tinggi. Cocok digunakan untuk berbagai "
                          "keperluan rumah tangga. Desainnya sederhana namun "
                          "fungsional, serta mendukung gaya hidup berkelanjutan.",
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/checkout');
                  },
                  child: const CustomText(
                    "Beli Sekarang",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
