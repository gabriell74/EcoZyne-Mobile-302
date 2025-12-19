import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/models/waste_bank_submission.dart';
import 'package:ecozyne_mobile/data/services/openstreetmap_service.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/address_section.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/contact_section.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/document_section.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/identitas_section.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/map_section.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/photo_section.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/section_header.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/submit_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/slide_fade_in.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_submission_provider.dart';
import 'package:ecozyne_mobile/data/providers/region_provider.dart';

class WasteBankRegisterScreen extends StatefulWidget {
  const WasteBankRegisterScreen({super.key});

  @override
  State<WasteBankRegisterScreen> createState() =>
      _WasteBankRegisterScreenState();
}

class _WasteBankRegisterScreenState extends State<WasteBankRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final MapController _mapController = MapController();

  // Controllers
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  // State
  LatLng? _selectedLocation;
  String? _selectedImagePath;
  String? _selectedPdfPath;
  bool _isFetchingAddress = false;
  bool _isSubmitting = false;

  // Constants
  final LatLng defaultCenter = const LatLng(1.0456, 104.0305);
  final double defaultZoom = 12.0;
  final LatLngBounds batamBounds = LatLngBounds(
    const LatLng(0.9550, 103.7850),
    const LatLng(1.2100, 104.1750),
  );

  // Services
  final OpenStreetMapService _osmService = OpenStreetMapService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final regionProvider = context.read<RegionProvider>();
      regionProvider.reset();
      regionProvider.loadRegions();
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
    _postalCodeController.dispose();
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

      if (file.size > 5 * 1024 * 1024) {
        if (mounted) {
          showErrorTopSnackBar(context, "File terlalu besar. Maksimal 5MB");
        }
        return;
      }

      setState(() => _selectedPdfPath = file.path!);
    }
  }

  Future<void> _fetchAddressFromCoordinates() async {
    if (_selectedLocation == null) return;

    setState(() {
      _isFetchingAddress = true;
      _postalCodeController.clear();
    });

    try {
      final postalCode = await _osmService.getPostalCode(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );

      if (mounted && postalCode != null) {
        setState(() {
          _postalCodeController.text = postalCode;
          _isFetchingAddress = false;
        });
      } else {
        setState(() => _isFetchingAddress = false);
      }
    } catch (e) {
      print('Error fetching postal code: $e');
      if (mounted) {
        setState(() => _isFetchingAddress = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal mendeteksi kode pos'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String _buildFullAddress(RegionProvider regionProvider) {
    final selectedKecamatan = regionProvider.selectedKecamatan;
    final selectedKelurahan = regionProvider.selectedKelurahan;

    return "${_addressController.text.trim()}\n"
        "RT ${_rtController.text.trim()} / RW ${_rwController.text.trim()}\n"
        "Kelurahan ${selectedKelurahan?.kelurahan ?? ''}\n"
        "Kecamatan ${selectedKecamatan?.kecamatan ?? ''}\n"
        "Kode Pos ${_postalCodeController.text.trim()}\n"
        "Kota Batam\n"
        "Provinsi Kepulauan Riau";
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      showErrorTopSnackBar(context, "Periksa kembali inputan");
      return;
    }

    final regionProvider = context.read<RegionProvider>();

    // Validations
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

    if (_postalCodeController.text.isEmpty) {
      showErrorTopSnackBar(context, "Kode pos wajib diisi");
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

    setState(() => _isSubmitting = true);

    try {
      final provider = context.read<WasteBankSubmissionProvider>();

      final submission = WasteBankSubmission(
        wasteBankName: _bankNameController.text,
        wasteBankLocation: _buildFullAddress(regionProvider),
        photoPath: _selectedImagePath!,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        fileDocumentPath: _selectedPdfPath!,
        notes: _descriptionController.text,
      );

      final success = await provider.addSubmission(submission.toMap());

      if (success) {
        showSuccessTopSnackBar(
          context,
          "Pendaftaran sedang diproses",
          icon: const Icon(Icons.pending_actions),
        );
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        showErrorTopSnackBar(context, provider.message);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
              child: LoadingWidget(),
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
                      const SectionHeader(title: "IDENTITAS"),
                      IdentitasSection(bankNameController: _bankNameController),

                      // FOTO BANK SAMPAH
                      const SectionHeader(title: "Foto Bank Sampah"),
                      PhotoSection(
                        initialImagePath: _selectedImagePath,
                        onImageSelected: (file) {
                          setState(() {
                            _selectedImagePath = file?.path;
                          });
                        },
                      ),

                      // LOKASI & ALAMAT
                      const SectionHeader(title: "LOKASI & ALAMAT"),
                      MapSection(
                        mapController: _mapController,
                        defaultCenter: defaultCenter,
                        defaultZoom: defaultZoom,
                        batamBounds: batamBounds,
                        selectedLocation: _selectedLocation,
                        onLocationSelected: (loc) {
                          setState(() => _selectedLocation = loc);
                          _fetchAddressFromCoordinates();
                        },
                        onFetchAddress: _fetchAddressFromCoordinates,
                      ),

                      // DETAIL ALAMAT
                      AddressSection(
                        addressController: _addressController,
                        rtController: _rtController,
                        rwController: _rwController,
                        postalCodeController: _postalCodeController,
                        selectedLocation: _selectedLocation,
                        isFetchingAddress: _isFetchingAddress,
                      ),

                      // KONTAK & OPERASIONAL
                      const SectionHeader(title: "KONTAK & OPERASIONAL"),
                      ContactSection(
                        whatsappController: _whatsappController,
                        descriptionController: _descriptionController,
                      ),

                      // DOKUMEN LEGALITAS
                      const SectionHeader(title: "DOKUMEN LEGALITAS"),
                      DocumentSection(
                        selectedPdfPath: _selectedPdfPath,
                        onPickPdf: _pickPDF,
                      ),

                      // BUTTON SUBMIT
                      SubmitButton(
                        onPressed: _submitForm,
                        isLoading: _isSubmitting,
                      ),

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