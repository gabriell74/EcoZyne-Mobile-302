import 'dart:convert';
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
import 'package:http/http.dart' as http;

// =============== SERVICE UNTUK OPENSTREETMAP ===============
class OpenStreetMapService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';
  
  /// Reverse Geocoding: Dapatkan alamat dari koordinat
  static Future<Map<String, dynamic>?> reverseGeocode(double lat, double lon) async {
    final url = Uri.parse(
      '$_baseUrl/reverse?format=json&lat=$lat&lon=$lon&addressdetails=1&zoom=18'
    );
    
    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'EcoZyneMobileApp/1.0',
          'Accept-Language': 'id',
          'Referer': 'ecozyne.app',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
    } catch (e) {
      print('OpenStreetMap Reverse Geocode Error: $e');
    }
    
    return null;
  }
  
  /// Ambil kode pos dari hasil reverse geocode
  static Future<String?> getPostalCode(double lat, double lon) async {
    final data = await reverseGeocode(lat, lon);
    
    if (data != null && data['address'] != null) {
      final address = data['address'] as Map<String, dynamic>;
      
      // Coba berbagai key untuk kode pos
      return address['postcode'] ?? 
             address['postal_code'] ?? 
             address['postalcode'];
    }
    
    return null;
  }
  
  /// Ambil alamat lengkap
  static Future<Map<String, String>?> getFullAddress(double lat, double lon) async {
    final data = await reverseGeocode(lat, lon);
    
    if (data != null && data['address'] != null) {
      final address = data['address'] as Map<String, dynamic>;
      
      return {
        'jalan': address['road'] ?? '',
        'kelurahan': address['village'] ?? address['suburb'] ?? '',
        'kecamatan': address['subdistrict'] ?? address['county'] ?? '',
        'kota': address['city'] ?? address['town'] ?? '',
        'provinsi': address['state'] ?? '',
        'kode_pos': address['postcode'] ?? address['postal_code'] ?? '',
        'negara': address['country'] ?? '',
        'display_name': data['display_name'] ?? '',
      };
    }
    
    return null;
  }
}
// ===========================================================

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
  final TextEditingController _postalCodeController = TextEditingController(); // TAMBAH

  LatLng? _selectedLocation;
  String? _selectedImagePath;
  String? _selectedPdfPath;
  bool _isFetchingAddress = false; // TAMBAH

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
    _postalCodeController.dispose(); // TAMBAH
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

  // TAMBAH: Method untuk fetch alamat dari koordinat
Future<void> _fetchAddressFromCoordinates() async {
  if (_selectedLocation == null) return;
  
  // Reset dulu
  setState(() {
    _postalCodeController.clear();
  });
  
  try {
    final postalCode = await OpenStreetMapService.getPostalCode(
      _selectedLocation!.latitude,
      _selectedLocation!.longitude,
    );
    
    if (mounted && postalCode != null) {
      setState(() {
        _postalCodeController.text = postalCode;
      });
    }
  } catch (e) {
    print('Error fetching postal code: $e');
    if (mounted) {
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
    return "${_addressController.text.trim()}\n"
        "RT ${_rtController.text.trim()} / RW ${_rwController.text.trim()}\n"
        "Kelurahan ${regionProvider.selectedKelurahan?.kelurahan ?? ''}\n"
        "Kecamatan ${regionProvider.selectedKecamatan?.kecamatan ?? ''}\n"
        "Kode Pos ${_postalCodeController.text.trim()}\n" // TAMBAH KODE POS
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

    // TAMBAH: Validasi kode pos
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
      "kelurahan_name": selectedKelurahan.kelurahan,
      "kecamatan_name": selectedKecamatan.kecamatan,
      "postal_code": _postalCodeController.text.trim(), // TAMBAH
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
              _fetchAddressFromCoordinates(); // AUTO FETCH
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
          // HAPUS loading indicator
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
          
          // RT DAN RW
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
                    BuildFormField(
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
                    BuildFormField(
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

          // KODE POS - AUTO DETECT (READONLY)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                "Kode Pos",
                fontSize: 14,
                color: Colors.black54,
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _postalCodeController,
                keyboardType: TextInputType.number,
                readOnly: true, // TIDAK BISA DIEDIT
                decoration: InputDecoration(
                  hintText: _selectedLocation == null 
                      ? "Pilih lokasi di peta dulu" 
                      : "Mendeteksi kode pos...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  prefixIcon: const Icon(Icons.local_post_office, size: 20),
                  suffixIcon: _postalCodeController.text.isNotEmpty
                      ? Icon(Icons.check_circle, color: Colors.green[600], size: 20)
                      : _selectedLocation != null
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                  filled: true,
                  fillColor: _postalCodeController.text.isNotEmpty
                      ? Colors.green[50]
                      : Colors.grey[50],
                ),
                validator: (value) {
                  if (_selectedLocation == null) {
                    return 'Pilih lokasi di peta terlebih dahulu';
                  }
                  if (value == null || value.isEmpty) {
                    return 'Sedang mendeteksi kode pos...';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),
              if (_selectedLocation != null && _postalCodeController.text.isEmpty)
                Text(
                  "Mendeteksi kode pos...",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              if (_postalCodeController.text.isNotEmpty)
                Text(
                  "Kode pos otomatis terdeteksi dari peta",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // KECAMATAN DROPDOWN
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
                child: DropdownButtonHideUnderline(
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
            ],
          ),

          const SizedBox(height: 16),

          // KELURAHAN DROPDOWN
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
                child: DropdownButtonHideUnderline(
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
            ],
          ),

          const SizedBox(height: 16),
          
          // WILAYAH ADMINISTRATIF
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