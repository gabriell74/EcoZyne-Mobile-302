import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/models/product.dart';
import 'package:ecozyne_mobile/data/providers/navigation_provider.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_product_provider.dart';
import 'package:ecozyne_mobile/features/manage_product/screens/add_product_screen.dart';
import 'package:ecozyne_mobile/features/manage_product/screens/edit_product_screen.dart';
import 'package:ecozyne_mobile/features/manage_product/widgets/manage_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WasteBankProductProvider>().getProduct();
    });
  }

  Future<void> _showConfirmDeleteDialog(int productId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        "Apakah kamu yakin ingin menghapus produk ini?",
        onTap: () => Navigator.pop(ctx, true),
      ),
    );

    if (confirmed != true) return;

    final provider = context.read<WasteBankProductProvider>();

    final success = await provider.deleteProduct(productId);

    if (success) {
      showSuccessTopSnackBar(
        context,
        "Berhasil Menghapus Produk",
      );
    } else {
      showErrorTopSnackBar(context, provider.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WasteBankProductProvider>();
    final List<Product> products = provider.products;
    final loading = provider.isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Kelola Produk", fontWeight: FontWeight.bold, fontSize: 18),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.pop(context);
              context.read<NavigationProvider>().setIndex(1);
            },
          ),
          const SizedBox(width: 12),
        ],
      ),

      body: AppBackground(
        child: loading
            ? const Center(child: LoadingWidget())
            : RefreshIndicator.adaptive(
          onRefresh: () async {
            await context.read<WasteBankProductProvider>().getProduct();
          },
          color: Colors.black,
          backgroundColor: const Color(0xFF55C173),
          child: CustomScrollView(
            slivers: [
              // Header Section - Selalu tampil
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF55C173), Color(0xFF45A563)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF55C173).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              icon: Icons.inventory_2_outlined,
                              label: 'Total Produk',
                              value: '${products.length}',
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            _buildStatItem(
                              icon: Icons.shopping_bag_outlined,
                              label: 'Stok Tersedia',
                              value: '${products.fold<int>(0, (sum, item) => sum + item.stock)}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section Title - Selalu tampil
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            'Daftar Produk',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AddProductScreen()),
                              );
                            },
                            icon: const Icon(Icons.add_circle_outline, size: 20),
                            label: const CustomText('Tambah Baru', fontSize: 14),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF55C173),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // Products Grid atau Empty State
              products.isEmpty
                  ? SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: EmptyState(
                    connected: provider.connected,
                    message: provider.message,
                  ),
                ),
              )
                  : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 2,
                  childCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ManageProductCard(
                      product: product,
                      onDelete: () => _showConfirmDeleteDialog(product.id),
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProductScreen(
                              productId: product.id,
                              initialName: product.productName,
                              initialPrice: product.price.toString(),
                              initialDescription: product.description,
                              initialStock: product.stock.toString(),
                              initialImageUrl: product.photo,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Bottom Spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        CustomText(
          value,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        const SizedBox(height: 4),
        CustomText(
          label,
          fontSize: 12,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ],
    );
  }
}