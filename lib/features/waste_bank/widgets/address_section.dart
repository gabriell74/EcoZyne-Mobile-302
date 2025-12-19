import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/build_form_field.dart';
import 'package:ecozyne_mobile/data/providers/region_provider.dart';
import 'package:ecozyne_mobile/data/models/region.dart';

class AddressSection extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController rtController;
  final TextEditingController rwController;
  final TextEditingController postalCodeController;
  final LatLng? selectedLocation;
  final bool isFetchingAddress;

  const AddressSection({
    super.key,
    required this.addressController,
    required this.rtController,
    required this.rwController,
    required this.postalCodeController,
    required this.selectedLocation,
    required this.isFetchingAddress,
  });

  @override
  Widget build(BuildContext context) {
    final regionProvider = context.watch<RegionProvider>();

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
            controller: addressController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Alamat wajib diisi';
              }
              if (value.length < 10) {
                return 'Alamat terlalu pendek';
              }
              return null;
            },
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
                      controller: rtController,
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
                      controller: rwController,
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

          // KODE POS
          _buildPostalCodeField(),

          const SizedBox(height: 16),

          // KECAMATAN DROPDOWN
          _buildKecamatanDropdown(regionProvider),

          const SizedBox(height: 16),

          // KELURAHAN DROPDOWN
          _buildKelurahanDropdown(regionProvider),

          const SizedBox(height: 16),

          // WILAYAH ADMINISTRATIF
          _buildAdministrativeRegion(),
        ],
      ),
    );
  }

  Widget _buildPostalCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          "Kode Pos",
          fontSize: 14,
          color: Colors.black54,
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: postalCodeController,
          keyboardType: TextInputType.number,
          readOnly: true,
          decoration: InputDecoration(
            hintText: selectedLocation == null
                ? "Pilih lokasi di peta dulu"
                : "Mendeteksi kode pos...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            prefixIcon: const Icon(Icons.local_post_office, size: 20),
            suffixIcon: postalCodeController.text.isNotEmpty
                ? Icon(Icons.check_circle, color: Colors.green[600], size: 20)
                : selectedLocation != null && isFetchingAddress
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Icon(Icons.location_on, color: Colors.grey[600], size: 20),
            filled: true,
            fillColor: postalCodeController.text.isNotEmpty
                ? Colors.green[50]
                : Colors.grey[50],
          ),
          validator: (value) {
            if (selectedLocation == null) {
              return 'Pilih lokasi di peta terlebih dahulu';
            }
            if (value == null || value.isEmpty) {
              return 'Sedang mendeteksi kode pos...';
            }
            return null;
          },
        ),
        const SizedBox(height: 6),
        if (selectedLocation != null && postalCodeController.text.isEmpty && isFetchingAddress)
          Text(
            "Mendeteksi kode pos...",
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[700],
              fontStyle: FontStyle.italic,
            ),
          ),
        if (postalCodeController.text.isNotEmpty)
          Text(
            "Kode pos otomatis terdeteksi dari peta",
            style: TextStyle(
              fontSize: 12,
              color: Colors.green[700],
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  Widget _buildKecamatanDropdown(RegionProvider regionProvider) {
    return Column(
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
    );
  }

  Widget _buildKelurahanDropdown(RegionProvider regionProvider) {
    return Column(
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
    );
  }

  Widget _buildAdministrativeRegion() {
    return Container(
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
    );
  }
}