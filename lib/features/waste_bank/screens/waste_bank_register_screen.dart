import 'dart:io';

import 'package:ecozyne_mobile/core/widgets/build_form_field.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/image_picker_field.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_submission_provider.dart';
import 'package:ecozyne_mobile/data/providers/region_provider.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/map_selection_widget.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/pdf_upload_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/slide_fade_in.dart';
import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:ecozyne_mobile/data/models/region.dart';

class WasteBankRegisterScreen extends StatefulWidget {
  const WasteBankRegisterScreen({super.key});

  @override
  State<WasteBankRegisterScreen> createState() =>
      _WasteBankRegisterScreenState();
}

class _WasteBankRegisterScreenState extends State<WasteBankRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final MapController _mapController = MapController();

  // Controller
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  LatLng? _selectedLocation;
  String? _selectedImagePath;
  String? _selectedPdfPath;

  final LatLng defaultCenter = const LatLng(1.0456, 104.0305);
  final double defaultZoom = 12.0;
  final LatLngBounds batamBounds = LatLngBounds(
    const LatLng(0.9550, 103.7850),
    const LatLng(1.2100, 104.1750),
  );

  @override
  void initState() {
    super.initState();
    // Load data region saat screen pertama kali muncul
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegionProvider>().loadRegions();
    });
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _addressController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _whatsappController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final file = result.files.first;

      // Validasi ukuran file (5MB)
      if (file.size > 5 * 1024 * 1024) {
        if (context.mounted) {
          showErrorTopSnackBar(context, "File terlalu besar. Maksimal 5MB");
        }
        return;
      }

      setState(() => _selectedPdfPath = file.path!);
    }
  }

  String _buildFullAddress(RegionProvider regionProvider) {
    return "${_addressController.text.trim()}\n"
        "RT ${_rtController.text.trim()} / RW ${_rwController.text.trim()}\n"
        "Kelurahan ${regionProvider.selectedKelurahan?.kelurahan ?? ''}\n" // GANTI: .kelurahan
        "Kecamatan ${regionProvider.selectedKecamatan?.kecamatan ?? ''}\n" // GANTI: .kecamatan
        "Kota Batam\n"
        "Provinsi Kepulauan Riau";
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      showErrorTopSnackBar(context, "Periksa kembali inputan");
      return;
    }

    final regionProvider = context.read<RegionProvider>();

    if (regionProvider.selectedKecamatan == null) {
      showErrorTopSnackBar(context, "Pilih kecamatan terlebih dahulu");
      return;
    }

    if (regionProvider.selectedKelurahan == null) {
      showErrorTopSnackBar(context, "Pilih kelurahan terlebih dahulu");
      return;
    }

    if (_selectedImagePath == null) {
      showErrorTopSnackBar(context, "Unggah foto terlebih dahulu");
      return;
    }

    if (_selectedPdfPath == null) {
      showErrorTopSnackBar(context, "Harap unggah file pengajuan");
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

    // Simpan ke variabel lokal untuk menghindari null safety warning
    final selectedKecamatan = regionProvider.selectedKecamatan!;
    final selectedKelurahan = regionProvider.selectedKelurahan!;

    final success = await provider.addSubmission({
      "waste_bank_name": _bankNameController.text,
      "waste_bank_location": _buildFullAddress(regionProvider),
      "photo": _selectedImagePath!,
      "latitude": _selectedLocation!.latitude,
      "longitude": _selectedLocation!.longitude,
      "file_document": _selectedPdfPath!,
      "notes": _descriptionController.text,
      "status": "pending",
      "rt": _rtController.text.trim(),
      "rw": _rwController.text.trim(),
      "kelurahan_id": selectedKelurahan.id,
      "kecamatan_id": selectedKecamatan.id,
      "kelurahan_name": selectedKelurahan.kelurahan, // GANTI: .kelurahan
      "kecamatan_name": selectedKecamatan.kecamatan, // GANTI: .kecamatan
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

  // =============== HELPER WIDGETS ===============

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: CustomText(
        title,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildIdentitasSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            "Nama Bank Sampah",
            fontSize: 14,
            color: Colors.black54,
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: _bankNameController,
              decoration: const InputDecoration(
                hintText: "Contoh: Bank Sampah Bersih Jaya",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              validator: Validators.bankName,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            "Unggah foto lokasi bank sampah",
            fontSize: 14,
            color: Colors.black54,
          ),
          const SizedBox(height: 8),
          ImagePickerField(
            label: "Pilih Foto",
            initialImage: _selectedImagePath != null ? File(_selectedImagePath!) : null,
            onImageSelected: (file) {
              setState(() {
                _selectedImagePath = file?.path;
              });
            },
          ),
          const SizedBox(height: 4),
          const CustomText(
            "Format: JPG/PNG, Maks. 5MB",
            fontSize: 12,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            "Pilih Lokasi di Peta",
            fontSize: 14,
            color: Colors.black54,
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 12),
          if (_selectedLocation != null) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        "Latitude",
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      CustomText(
                        _selectedLocation!.latitude.toStringAsFixed(6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        "Longitude",
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      CustomText(
                        _selectedLocation!.longitude.toStringAsFixed(6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailAlamatSection(BuildContext context, RegionProvider regionProvider) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const CustomText(
          "Alamat Lengkap",
          fontSize: 14,
          color: Colors.black54,
        ),
        const SizedBox(height: 8),
        BuildFormField(
          label: "Nama jalan, nomor rumah, patokan...",
          controller: _addressController,
          validator: Validators.address,
        ),

        const SizedBox(height: 16),
        
        // RT DAN RW DENGAN TAMPILAN YANG SAMA
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    "RT",
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 4),
                  BuildFormField( // GUNAKAN BuildFormField JUGA
                    label: "001",
                    controller: _rtController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'RT wajib diisi';
                      }
                      if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                        return 'RT harus 3 digit';
                      }
                      return null;
                    },
                    prefixIcon: null, 
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    "RW",
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 4),
                  BuildFormField( // GUNAKAN BuildFormField JUGA
                    label: "005",
                    controller: _rwController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'RW wajib diisi';
                      }
                      if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                        return 'RW harus 3 digit';
                      }
                      return null;
                    },
                    prefixIcon: null,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // KECAMATAN DROPDOWN - TAMPILAN YANG LEBIH BAIK
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              "Kecamatan",
              fontSize: 14,
              color: Colors.black54,
            ),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline( // HILANGKAN GARIS BAWAH
                child: DropdownButton<Kecamatan>(
                  value: regionProvider.selectedKecamatan,
                  hint: const Text(
                    "Pilih Kecamatan",
                    style: TextStyle(color: Colors.grey),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  items: regionProvider.kecamatanList.map((kecamatan) {
                    return DropdownMenuItem<Kecamatan>(
                      value: kecamatan,
                      child: Text(
                        kecamatan.kecamatan,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    regionProvider.selectKecamatan(value);
                  },
                ),
              ),
            ),
            // TAMBAHKAN VALIDATOR TEXT DI BAWAH
            if (regionProvider.selectedKecamatan != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[600], size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          regionProvider.selectedKecamatan!.kecamatan,
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 16),

        // KELURAHAN DROPDOWN - TAMPILAN YANG LEBIH BAIK
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              "Kelurahan",
              fontSize: 14,
              color: Colors.black54,
            ),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline( // HILANGKAN GARIS BAWAH
                child: DropdownButton<Kelurahan>(
                  value: regionProvider.selectedKelurahan,
                  hint: const Text(
                    "Pilih Kelurahan",
                    style: TextStyle(color: Colors.grey),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  items: regionProvider.kelurahanList.map((kelurahan) {
                    return DropdownMenuItem<Kelurahan>(
                      value: kelurahan,
                      child: Text(
                        kelurahan.kelurahan,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: regionProvider.selectedKecamatan != null
                      ? (value) {
                          regionProvider.selectKelurahan(value);
                        }
                      : null,
                ),
              ),
            ),
            // TAMBAHKAN VALIDATOR TEXT DI BAWAH
            if (regionProvider.selectedKelurahan != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[600], size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          regionProvider.selectedKelurahan!.kelurahan,
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 16),
        // WILAYAH ADMINISTRATIF - PERBAIKI LAYOUT
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                "WILAYAH ADMINISTRATIF",
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kota",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Batam",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Provinsi",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Kepulauan Riau",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildKontakSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            "Nomor WhatsApp",
            fontSize: 14,
            color: Colors.black54,
          ),
          const SizedBox(height: 8),
          BuildFormField(
            label: "08xx-xxxx-xxxx",
            controller: _whatsappController,
            validator: Validators.whatsapp,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone,
          ),

          const SizedBox(height: 16),
          const CustomText(
            "Deskripsi Bank Sampah",
            fontSize: 14,
            color: Colors.black54,
          ),
          const SizedBox(height: 8),
          BuildFormField(
            label: "Jelaskan profil dan jenis sampah yang ditampung",
            controller: _descriptionController,
            maxLines: 4,
            validator: Validators.description,
            hintText: "Bank Sampah kami berfokus pada daur ulang plastik dan kertas...",
          ),
        ],
      ),
    );
  }

  Widget _buildDokumenSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            "Surat Pengajuan (PDF)",
            fontSize: 14,
            color: Colors.black54,
          ),
          const SizedBox(height: 8),
          PdfUploadWidget(
            selectedPdfPath: _selectedPdfPath,
            onPickPdf: _pickPDF,
          ),
          const SizedBox(height: 4),
          const CustomText(
            "Maksimal 5MB",
            fontSize: 12,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF55C173),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
          ),
          child: const CustomText(
            "Kirim Pendaftaran",
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const CustomText("Daftar Bank Sampah", fontWeight: FontWeight.bold, fontSize: 18),
        centerTitle: true,
      ),
      body: Consumer<RegionProvider>(
        builder: (context, regionProvider, _) {
          if (regionProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return AppBackground(
            child: SlideFadeIn(
              delayMilliseconds: 200,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IDENTITAS
                      _buildSectionHeader("IDENTITAS"),
                      _buildIdentitasSection(),

                      // FOTO BANK SAMPAH
                      _buildSectionHeader("Foto Bank Sampah"),
                      _buildPhotoSection(),

                      // LOKASI & ALAMAT
                      _buildSectionHeader("LOKASI & ALAMAT"),
                      _buildMapSection(),

                      // DETAIL ALAMAT
                      _buildDetailAlamatSection(context, regionProvider),

                      // KONTAK & OPERASIONAL
                      _buildSectionHeader("KONTAK & OPERASIONAL"),
                      _buildKontakSection(),

                      // DOKUMEN LEGALITAS
                      _buildSectionHeader("DOKUMEN LEGALITAS"),
                      _buildDokumenSection(),

                      // BUTTON SUBMIT
                      _buildSubmitButton(),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}