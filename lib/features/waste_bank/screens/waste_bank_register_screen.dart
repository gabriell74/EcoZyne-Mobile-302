import 'package:ecozyne_mobile/core/widgets/build_form_field.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_submission_provider.dart';
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
import 'package:provider/provider.dart';

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

  final LatLng defaultCenter = const LatLng(1.0456, 104.0305);
  final double defaultZoom = 12.0;
  final LatLngBounds batamBounds = LatLngBounds(
    const LatLng(0.9550, 103.7850),
    const LatLng(1.2100, 104.1750),
  );

  @override
  void initState() {
    super.initState();

    _addressController.text =
    "Nama Jalan .................... No. ....,\n"
        "RT .. / RW ..,\n"
        "Kelurahan ....................,\n"
        "Kecamatan ....................,\n"
        "Kota Batam,\n"
        "Provinsi Kepulauan Riau,\n";
  }

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
                final file =
                await _picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, file);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () async {
                final file =
                await _picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, file);
              },
            ),
          ],
        ),
      ),
    );

    if (picked != null) {
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      showErrorTopSnackBar(context, "Periksa kembali inputan");
      return;
    }

    if (_selectedImagePath == null) {
      showErrorTopSnackBar(context, "Unggah foto terlebih dahulu");
      return;
    }

    if (_selectedPdfPath == null) {
      showErrorTopSnackBar(context, "Harap unggah file persetujuan");
      return;
    }

    if (_selectedLocation == null) {
      showErrorTopSnackBar(context, "Pilih lokasi di peta dulu");
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        "Kirim pendaftaran Bank Sampah?",
        onTap: () => Navigator.pop(ctx, true),
      ),
    );

    if (confirmed != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingWidget(height: 100),
    );

    final provider = context.read<WasteBankSubmissionProvider>();

    final success = await provider.addSubmission({
      "waste_bank_name": _bankNameController.text,
      "waste_bank_location": _addressController.text,
      "photo": _selectedImagePath!,
      "latitude": _selectedLocation!.latitude.toString(),
      "longitude": _selectedLocation!.longitude.toString(),
      "file_document": _selectedPdfPath!,
      "notes": _descriptionController.text,
      "status": "pending",
    });


    if (context.mounted) Navigator.pop(context);

    if (success) {
      showSuccessTopSnackBar(
        context,
        "Pendaftaran sedang diproses",
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                  onLocationSelected: (loc) {
                    setState(() => _selectedLocation = loc);
                  },
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ImageUploadWidget(
                          selectedImagePath: _selectedImagePath,
                          onPickImage: _pickImage,
                          onRemoveImage: () =>
                              setState(() => _selectedImagePath = null),
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
                          maxLines: 4,
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
                          label: "Deskripsi Bank Sampah",
                          controller: _descriptionController,
                          maxLines: 4,
                          validator: Validators.description,
                          hintText: "Jenis sampah, dsb",
                        ),

                        const SizedBox(height: 4),

                        PdfUploadWidget(
                          selectedPdfPath: _selectedPdfPath,
                          onPickPdf: _pickPDF,
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF55C173),
                              padding: const EdgeInsets.symmetric(
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

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
