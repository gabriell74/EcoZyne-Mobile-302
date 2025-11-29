import 'package:ecozyne_mobile/core/widgets/build_form_field.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/image_upload_widget.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/map_selection_widget.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/pdf_upload_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/slide_fade_in.dart';
import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:latlong2/latlong.dart';

class WasteBankRegisterScreen extends StatefulWidget {
  const WasteBankRegisterScreen({super.key});

  @override
  State<WasteBankRegisterScreen> createState() =>
      _WasteBankRegisterScreenState();
}

class _WasteBankRegisterScreenState extends State<WasteBankRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final MapController _mapController = MapController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  LatLng? _selectedLocation;
  String? _selectedImagePath;
  String? _selectedPdfPath;

  final ImagePicker _picker = ImagePicker();

  // Batam Configuration
  final LatLng defaultCenter = const LatLng(1.0456, 104.0305);
  final double defaultZoom = 12.0;
  final LatLngBounds batamBounds = LatLngBounds(
    const LatLng(0.9550, 103.7850),
    const LatLng(1.2100, 104.1750),
  );

  @override
  void dispose() {
    _bankNameController.dispose();
    _addressController.dispose();
    _whatsappController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Periksa kembali inputan')),
      );
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

    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih lokasi di peta dulu')),
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
            child: Column(
              children: [
                MapSelectionWidget(
                  mapController: _mapController,
                  defaultCenter: defaultCenter,
                  defaultZoom: defaultZoom,
                  batamBounds: batamBounds,
                  selectedLocation: _selectedLocation,
                  onLocationSelected: (location) {
                    setState(() => _selectedLocation = location);
                  },
                ),

                const SizedBox(height: 12),

                const CustomText(
                  "Pilih Lokasi di Peta",
                  fontWeight: FontWeight.bold,
                ),

                const SizedBox(height: 6),

                if (_selectedLocation != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "Latitude: ${_selectedLocation!.latitude.toStringAsFixed(6)}",
                        fontSize: 14,
                      ),
                      CustomText(
                        "Longitude: ${_selectedLocation!.longitude.toStringAsFixed(6)}",
                        fontSize: 14,
                      ),
                    ],
                  ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageUploadWidget(
                          selectedImagePath: _selectedImagePath,
                          onPickImage: _pickImage,
                          onRemoveImage: () {
                            setState(() => _selectedImagePath = null);
                          },
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

                        PdfUploadWidget(
                          selectedPdfPath: _selectedPdfPath,
                          onPickPdf: _pickPDF,
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
              ],
            ),
          )
        ),
      ),
    );
  }
}