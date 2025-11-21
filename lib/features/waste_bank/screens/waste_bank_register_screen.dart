import 'dart:io';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/slide_fade_in.dart';
import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ecozyne_mobile/core/widgets/build_form_field.dart';

class WasteBankRegisterScreen extends StatefulWidget {
  const WasteBankRegisterScreen({super.key});

  @override
  State<WasteBankRegisterScreen> createState() =>
      _WasteBankRegisterScreenState();
}

class _WasteBankRegisterScreenState extends State<WasteBankRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String? _selectedImagePath;
  String? _selectedPdfPath;

  Future<void> _pickImage() async {
    final XFile? picked = await showModalBottomSheet<XFile?>(
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

    if (picked != null && picked.path.isNotEmpty) {
      setState(() => _selectedImagePath = picked.path);
    }
  }

  Future<void> _pickPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() => _selectedPdfPath = result.files.single.path!);
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Periksa kembali inputan')));
      return;
    }

    if (_selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const CustomText(
            'Unggah foto terlebih dahulu',
            color: Colors.white,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    if (_selectedPdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const CustomText(
            'Harap unggah file persetujuan',
            color: Colors.white,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    showSuccessTopSnackBar(
      context,
      "Pendaftaran diproses. Menunggu persetujuan admin.",
      icon: const Icon(Icons.pending_actions, size: 10),
    );
    Navigator.pop(context);
  }

  Widget _buildUploadBox({
    required String label,
    required String placeholder,
    required IconData icon,
    required VoidCallback onTap,
    String? filePath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, fontWeight: FontWeight.w500),
        const SizedBox(height: 0),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFB9F5C6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    filePath != null
                        ? File(filePath).path.split('/').last
                        : placeholder,
                    color: Colors.black87,
                  ),
                ),
                Icon(icon, color: Colors.black54),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Daftar Bank Sampah"),
        centerTitle: true,
      ),
      body: AppBackground(
        child: SlideFadeIn(
          delayMilliseconds: 200,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText("Unggah Foto", fontWeight: FontWeight.bold),
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: _selectedImagePath == null
                          ? const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 50,
                                color: Colors.black45,
                              ),
                            )
                          : Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_selectedImagePath!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _selectedImagePath = null,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  BuildFormField(
                    label: "Nama Bank Sampah",
                    controller: _bankNameController,
                    validator: Validators.bankName,
                    prefixIcon: Icons.recycling,
                  ),

                  BuildFormField(
                    label: "Alamat",
                    controller: _addressController,
                    validator: Validators.address,
                    prefixIcon: Icons.location_on,
                  ),

                  BuildFormField(
                    label: "Nomor WhatsApp",
                    controller: _whatsappController,
                    validator: Validators.whatsapp,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                  ),

                  BuildFormField(
                    label: "Deskripsi",
                    controller: _descriptionController,
                    validator: Validators.description,
                    hintText: "Jenis sampah, dsb",
                    maxLines: 4,
                  ),

                  const SizedBox(height: 4),
                  const CustomText(
                    "Surat Pernyataan",
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),

                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(
                        'https://example.com/surat_pernyataan.pdf',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    child: const Text(
                      'Download file',
                      style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: const Offset(0, -15),
                    child: _buildUploadBox(
                      label: "",
                      placeholder: "Unggah file PDF",
                      icon: Icons.upload_file,
                      onTap: _pickPDF,
                      filePath: _selectedPdfPath,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF55C173),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const CustomText(
                        "Kirim Pendaftaran",
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
