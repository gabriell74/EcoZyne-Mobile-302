import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProdukScreenState();
}

class _EditProdukScreenState extends State<EditProductScreen> {
  final _picker = ImagePicker();
  File? _selectedImage;

  final TextEditingController namaCtrl = TextEditingController(
    text: 'Bank Sampah A',
  );
  final TextEditingController hargaCtrl = TextEditingController(text: '10000');
  final TextEditingController alamatCtrl = TextEditingController(
    text: 'Jl. Contoh No. 1',
  );

  Future<void> _pickImage() async {
    final picked = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                final file = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                Navigator.pop(context, file);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () async {
                final file = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                Navigator.pop(context, file);
              },
            ),
          ],
        ),
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Edit Produk')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Unggah Foto Produk'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : Image.asset(
                        'assets/images/cover1.png',
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: namaCtrl,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            TextField(
              controller: hargaCtrl,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: alamatCtrl,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
