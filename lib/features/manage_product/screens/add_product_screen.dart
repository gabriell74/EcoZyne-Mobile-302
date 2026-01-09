import 'dart:io';
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

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedImagePath;

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController stockCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    addressCtrl.dispose();
    descriptionCtrl.dispose();
    stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      showErrorTopSnackBar(context, "Periksa kembali inputan");
      return;
    }

    if (_selectedImagePath == null) {
      showErrorTopSnackBar(context, "Unggah foto terlebih dahulu");
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        "Tambah Produk Baru?",
        onTap: () => Navigator.pop(ctx, true),
      ),
    );

    if (confirmed != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingWidget(height: 100),
    );

    final provider = context.read<WasteBankProductProvider>();

    final success = await provider.addProduct({
      "product_name": nameCtrl.text,
      "description": descriptionCtrl.text,
      "price": double.parse(priceCtrl.text),
      "stock": int.parse(stockCtrl.text),
      "photo": _selectedImagePath!,
    });

    if (context.mounted) Navigator.pop(context);

    if (success) {
      showSuccessTopSnackBar(
        context,
        "Berhasil Menambah Produk",
        icon: const Icon(Icons.pending_actions),
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
          'Tambah Produk',
          color: Colors.grey.shade900,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey.shade800,
            size: 20,
          ),
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
                  initialImage: _selectedImagePath != null ? File(_selectedImagePath!) : null,
                  onImageSelected: (file) {
                    setState(() => _selectedImagePath = file?.path);
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
                    if (int.tryParse(v) == null) return "Harga harus berupa angka";
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
                    if (int.tryParse(v) == null) return "Stok harus berupa angka";
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
                      onPressed: _submitForm,
                      child: const CustomText(
                        "Tambah Produk",
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
