import 'dart:io';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/build_form_field.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/image_picker_field.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  final TextEditingController namaCtrl = TextEditingController();
  final TextEditingController hargaCtrl = TextEditingController();
  final TextEditingController alamatCtrl = TextEditingController();
  final TextEditingController deskripsiCtrl = TextEditingController();
  final TextEditingController stokCtrl = TextEditingController();

  @override
  void dispose() {
    namaCtrl.dispose();
    hargaCtrl.dispose();
    alamatCtrl.dispose();
    deskripsiCtrl.dispose();
    stokCtrl.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Silakan unggah foto produk terlebih dahulu"),
            backgroundColor: Colors.orange.shade400,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Produk berhasil ditambahkan!"),
          backgroundColor: Colors.green.shade500,
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
          'Tambah Produk',
          color: Colors.grey.shade900,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
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
                  initialImage: _selectedImage,
                  onImageSelected: (file) {
                    setState(() => _selectedImage = file);
                  },
                ),

                const SizedBox(height: 28),

                BuildFormField(
                  label: "Nama Produk",
                  controller: namaCtrl,
                  hintText: "Contoh: Tas Rajut Handmade",
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
                        "Buat Order",
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
