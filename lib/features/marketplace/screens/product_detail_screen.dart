import 'package:ecozyne_mobile/core/utils/price_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/build_image_section.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/login_required_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/models/product.dart';
import 'package:ecozyne_mobile/data/providers/product_detail_provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/marketplace/screens/checkout_screen.dart';
import 'package:ecozyne_mobile/features/marketplace/widgets/feature_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ProductDetailProvider>()
          .fetchProductDetail(widget.product.id);
    });
  }

  @override
  void dispose() {
    context.read<ProductDetailProvider>().clear();
    super.dispose();
  }

  Future<void> _showConfirmDialog(
      BuildContext context, {
        required int productId,
        required String customerName,
        required String phoneNumber,
        required String orderAddress,
        required int amount,
      }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmationDialog(
        "Apakah anda yakin membeli produk ini?",
        onTap: () => Navigator.pop(context, true),
      ),
    );

    if (confirmed != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingWidget(height: 100),
    );

    final detailProvider = context.read<ProductDetailProvider>();

    final success = await detailProvider.placeOrder(
      productId: productId,
      customerName: customerName,
      phoneNumber: phoneNumber,
      orderAddress: orderAddress,
      amount: amount,
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (success) {
      showSuccessTopSnackBar(
        context,
        "Pesanan Sedang Diproses",
        icon: const Icon(Icons.shopping_bag),
      );

      detailProvider.fetchProductDetail(productId);

      Navigator.pop(context);
    } else {
      showErrorTopSnackBar(context, detailProvider.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Product baseProduct = widget.product;

    final Product? apiProduct =
        context.watch<ProductDetailProvider>().product;

    final bool isSameProduct =
        apiProduct != null && apiProduct.id == baseProduct.id;

    final int stock =
    isSameProduct ? apiProduct.stock : baseProduct.stock;

    final int price =
    isSameProduct ? apiProduct.price : baseProduct.price;

    final bool isOutOfStock = stock <= 0;

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
                  BuildImageSection(
                    id: baseProduct.id,
                    photo: baseProduct.photo,
                    tagPrefix: 'product',
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              price.toCurrency,
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
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(
                                    milliseconds: 250),
                                child: CustomText(
                                  "Stok: $stock",
                                  key: ValueKey(stock),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        const FeatureCard(
                          icon: Icons.local_shipping_outlined,
                          title: "Cash on Delivery",
                          subtitle:
                          "Pembayaran langsung saat barang diterima",
                          color: Color(0xFF55C173),
                        ),

                        const SizedBox(height: 12),

                        FeatureCard(
                          icon: Icons.recycling_outlined,
                          title: baseProduct.wasteBankName ??
                              "Bank Sampah",
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
                            borderRadius:
                            BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: CustomText(
                            baseProduct.description,
                            fontSize: 15,
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
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
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
                      color:
                      Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isOutOfStock
                            ? null
                            : () {
                          final userProvider =
                          context.read<UserProvider>();

                          if (userProvider.isGuest ||
                              userProvider.user == null) {
                            showDialog(
                              context: context,
                              builder: (_) =>
                              const LoginRequiredDialog(),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(
                                product: baseProduct,
                                onPressed: ({
                                  required String customerName,
                                  required String phoneNumber,
                                  required String orderAddress,
                                  required int amount,
                                }) {
                                  return _showConfirmDialog(
                                    context,
                                    productId: baseProduct.id,
                                    customerName: customerName,
                                    phoneNumber: phoneNumber,
                                    orderAddress: orderAddress,
                                    amount: amount,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                              isOutOfStock
                                  ? Icons.error_outline
                                  : Icons.shopping_bag_outlined,
                            ),
                            const SizedBox(width: 8),
                            CustomText(
                              isOutOfStock
                                  ? "Stok Habis"
                                  : "Beli Sekarang",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
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