import 'dart:io';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/build_form_field.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/image_picker_field.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  final String initialName;
  final String initialPrice;
  final String initialDescription;
  final String initialStock;
  final String initialImageUrl;

  const EditProductScreen({
    super.key,
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

  late TextEditingController namaCtrl;
  late TextEditingController hargaCtrl;
  late TextEditingController deskripsiCtrl;
  late TextEditingController stokCtrl;

  @override
  void initState() {
    super.initState();
    namaCtrl = TextEditingController(text: widget.initialName);
    hargaCtrl = TextEditingController(text: widget.initialPrice);
    deskripsiCtrl = TextEditingController(text: widget.initialDescription);
    stokCtrl = TextEditingController(text: widget.initialStock);
  }

  @override
  void dispose() {
    namaCtrl.dispose();
    hargaCtrl.dispose();
    deskripsiCtrl.dispose();
    stokCtrl.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Perubahan produk telah disimpan!"),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
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
          icon: Icon(Icons.arrow_back_ios_rounded,
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
                  controller: namaCtrl,
                  hintText: "Contoh: Eco Enzyme 1 Liter",
                  prefixIcon: Icons.inventory_2_rounded,
                  validator: (v) =>
                  v == null || v.isEmpty ? "Nama produk harus diisi" : null,
                ),

                BuildFormField(
                  label: "Harga",
                  controller: hargaCtrl,
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
                  controller: deskripsiCtrl,
                  hintText: "Tuliskan deskripsi produk...",
                  prefixIcon: Icons.description_rounded,
                  maxLines: 3,
                  validator: (v) =>
                  v == null || v.isEmpty ? "Deskripsi harus diisi" : null,
                ),

                BuildFormField(
                  label: "Stok",
                  controller: stokCtrl,
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
