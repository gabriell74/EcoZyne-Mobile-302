import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/models/product.dart';
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

  Future<bool> _showConfirmDeleteDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        "Apakah kamu yakin ingin menghapus produk ini?",
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText(
                "Produk berhasil dihapus",
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF55C173),
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WasteBankProductProvider>();
    final List<Product> products = provider.products;
    final loading = provider.isLoading;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText('Kelola Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductScreen()),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),

      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: loading
              ? const Center(child: LoadingWidget())
              : products.isEmpty
              ? Center(child: EmptyState(connected: provider.connected, message: provider.message,))
              : RefreshIndicator.adaptive(
                onRefresh: () async {
                  await context.read<WasteBankProductProvider>().getProduct();
                },
                color: Colors.black,
                backgroundColor: const Color(0xFF55C173),
                child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 2,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ManageProductCard(
                        product: product,
                        onDelete: () => _showConfirmDeleteDialog(context),
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProductScreen(
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
        ),
      ),
    );
  }
}