import 'package:ecozyne_mobile/core/utils/price_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/build_image_section.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/login_required_dialog.dart';
import 'package:ecozyne_mobile/data/models/product.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/marketplace/screens/checkout_screen.dart';
import 'package:ecozyne_mobile/features/marketplace/widgets/feature_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 BuildImageSection(id: product.id, photo: product.photo, tagPrefix: 'product'),

                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              product.price.toCurrency,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF55C173),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CustomText(
                                "Stok: ${product.stock.toString()}",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        FeatureCard(
                          icon: Icons.local_shipping_outlined,
                          title: "Cash on Delivery",
                          subtitle: "Pembayaran langsung saat barang diterima",
                          color: const Color(0xFF55C173),
                        ),

                        const SizedBox(height: 12),

                        FeatureCard(
                          icon: Icons.recycling_outlined,
                          title: product.wasteBankName ?? "Bank Sampah",
                          color: const Color(0xFF55C173),
                        ),

                        const SizedBox(height: 24),

                        const CustomText(
                          "Deskripsi Produk",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),

                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: CustomText(
                            product.description,
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              child: Material(
                color: Colors.black12.withValues(alpha: 0.5),
                shape: const CircleBorder(),
                elevation: 4,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                final userProvider = context.read<UserProvider>();

                                if (userProvider.isGuest || userProvider.user == null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => const LoginRequiredDialog(),
                                  );
                                } else {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (context) => CheckoutScreen(product: product),
                                  ));
                                }
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_bag_outlined, size: 20),
                                  SizedBox(width: 8),
                                  CustomText(
                                    "Beli Sekarang",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}