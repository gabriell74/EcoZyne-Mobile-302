import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/build_form_field.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/models/product.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/marketplace/widgets/product_checkout_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final Product product;
  final Future<void> Function({
  required String customerName,
  required String phoneNumber,
  required String orderAddress,
  required int amount,
  }) onPressed;


  const CheckoutScreen({super.key, required this.product, required this.onPressed});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  int _quantity = 1;

  Future<void> _submitCheckout() async {
    if (widget.product.stock <= 0) {
      showErrorTopSnackBar(context, "Stok produk habis");
      return;
    }

    if (_quantity > widget.product.stock) {
      showErrorTopSnackBar(context, "Jumlah melebihi stok tersedia");
      return;
    }

    if (_formKey.currentState!.validate()) {
      await widget.onPressed(
        customerName: _nameController.text,
        phoneNumber: _phoneController.text,
        orderAddress: _addressController.text,
        amount: _quantity,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();

      if (userProvider.user != null) {
        final community = userProvider.user!;
        _nameController.text = community.communityName;
        _phoneController.text = community.communityPhone;
        _addressController.text =
        "${community.communityAddress}, Kel. ${community.communityKelurahan}, "
            "Kec. ${community.communityKecamatan}, ${community.communityPostalCode}";
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = widget.product.stock <= 0;

    return AppBackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF55C173),
          elevation: 0,
          title: const Text("Checkout",),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF55C173).withValues(alpha: 0.1),
                            const Color(0xFF55C173).withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF55C173),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.shopping_cart_outlined),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  "Checkout Produk",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(height: 4),
                                CustomText(
                                  "Lengkapi informasi untuk melanjutkan",
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
      
                    const SizedBox(height: 28),
      
                    const CustomText(
                      "Informasi Pembeli",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 16),
      
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          BuildFormField(
                            label: "Nama Lengkap",
                            controller: _nameController,
                            validator: Validators.name,
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 8),
                          BuildFormField(
                            label: "Nomor WhatsApp",
                            controller: _phoneController,
                            validator: Validators.whatsapp,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.phone_outlined,
                          ),
                          const SizedBox(height: 8),
                          BuildFormField(
                            label: "Alamat Lengkap",
                            controller: _addressController,
                            validator: Validators.address,
                            maxLines: 3,
                            prefixIcon: Icons.location_on_outlined,
                          ),
                        ],
                      ),
                    ),
      
                    const SizedBox(height: 28),
      
                    ProductCheckoutDetail(
                      product: widget.product,
                      quantity: _quantity,
                      onIncrease: () {
                        if (_quantity < widget.product.stock) {
                          setState(() => _quantity++);
                        }
                      },
                      onDecrease: () {
                        if (_quantity > 1) {
                          setState(() => _quantity--);
                        }
                      },
                    ),
      
                    const SizedBox(height: 15),
      
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  "Metode Pembayaran",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade900,
                                ),
                                const SizedBox(height: 4),
                                CustomText(
                                  "Cash on Delivery (COD)\nBayar langsung saat barang diterima",
                                  fontSize: 12,
                                  color: Colors.blue.shade800,
                                  height: 1.4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
      
                    const SizedBox(height: 100),
                  ],
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
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isOutOfStock ? null : _submitCheckout,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isOutOfStock
                                  ? Icons.error_outline
                                  : Icons.check_circle_outline,
                            ),
                            const SizedBox(width: 10),
                            CustomText(
                              isOutOfStock ? "Stok Habis" : "Buat Order",
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
