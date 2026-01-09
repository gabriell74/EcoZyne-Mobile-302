import 'dart:io';
import 'package:ecozyne_mobile/core/utils/price_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/build_form_field.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/image_picker_field.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  final int productId;
  final String initialName;
  final String initialPrice;
  final String initialDescription;
  final String initialStock;
  final String initialImageUrl;

  const EditProductScreen({
    super.key,
    required this.productId,
    required this.initialName,
    required this.initialPrice,
    required this.initialDescription,
    required this.initialStock,
    required this.initialImageUrl,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController descriptionCtrl;
  late TextEditingController stockCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.initialName);
    priceCtrl = TextEditingController(text: widget.initialPrice.cleanPrice);
    descriptionCtrl = TextEditingController(text: widget.initialDescription);
    stockCtrl = TextEditingController(text: widget.initialStock);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    descriptionCtrl.dispose();
    stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _showConfirmationUpdateDialog() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        "Simpan perubahan produk?",
        onTap: () => Navigator.pop(ctx, true),
      ),
    );

    if (confirmed != true) return;

    final provider = context.read<WasteBankProductProvider>();

    final Map<String, dynamic> updateData = {
      "product_name": nameCtrl.text,
      "description": descriptionCtrl.text,
      "price": double.parse(priceCtrl.text),
      "stock": int.parse(stockCtrl.text),
    };

    if (_selectedImage != null) {
      updateData["photo"] = _selectedImage!.path;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (loadingContext) => const LoadingWidget(height: 100),
    );

    final success =
    await provider.updateProduct(widget.productId, updateData);

    if (context.mounted) Navigator.pop(context);

    if (success) {
      showSuccessTopSnackBar(
        context,
        provider.message,
        icon: const Icon(Icons.check_circle_rounded),
      );

      Navigator.pop(context);
    } else {
      showErrorTopSnackBar(context, provider.message);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: CustomText(
          'Edit Produk',
          color: Colors.grey.shade900,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.grey.shade800, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: AppBackground(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Informasi Produk',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                ),

                const SizedBox(height: 24),

                ImagePickerField(
                  label: "Foto Produk",
                  initialImageUrl: widget.initialImageUrl,
                  onImageSelected: (file) {
                    setState(() => _selectedImage = file);
                  },
                ),

                const SizedBox(height: 28),

                BuildFormField(
                  label: "Nama Produk",
                  controller: nameCtrl,
                  hintText: "Contoh: Eco Enzyme 1 Liter",
                  prefixIcon: Icons.inventory_2_rounded,
                  validator: (v) =>
                  v == null || v.isEmpty ? "Nama produk harus diisi" : null,
                ),

                BuildFormField(
                  label: "Harga",
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  hintText: "Contoh: 150000",
                  prefixIcon: Icons.payments_rounded,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Harga harus diisi";
                    if (double.tryParse(v) == null) return "Harga harus angka";
                    return null;
                  },
                ),

                BuildFormField(
                  label: "Deskripsi",
                  controller: descriptionCtrl,
                  hintText: "Tuliskan deskripsi produk...",
                  prefixIcon: Icons.description_rounded,
                  maxLines: 3,
                  validator: (v) =>
                  v == null || v.isEmpty ? "Deskripsi harus diisi" : null,
                ),

                BuildFormField(
                  label: "Stok",
                  controller: stockCtrl,
                  hintText: "Contoh: 10",
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.inventory_rounded,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Stok harus diisi";
                    if (int.tryParse(v) == null) return "Stok harus angka";
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _showConfirmationUpdateDialog,
                      child: const CustomText(
                        "Simpan Perubahan",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
