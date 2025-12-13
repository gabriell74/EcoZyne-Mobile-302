import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/waste_bank_submission.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/map_selection_widget.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/waste_bank_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WasteBankDetailScreen extends StatefulWidget {
  final WasteBankSubmission wasteBank;
  const WasteBankDetailScreen({super.key, required this.wasteBank});

  @override
  State<WasteBankDetailScreen> createState() => _WasteBankDetailScreenState();
}

class _WasteBankDetailScreenState extends State<WasteBankDetailScreen> {
  late final MapController _mapController;
  late final LatLng _bankLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _bankLocation = LatLng(
      widget.wasteBank.latitude,
      widget.wasteBank.longitude,
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        "Anda yakin memilih Bank Sampah ini?",
        onTap: () {
          Navigator.pop(context);

          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Berhasil memilih\nBank Sampah",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Bank Sampah", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: MapSelectionWidget(
                      mapController: _mapController,
                      defaultCenter: _bankLocation,
                      defaultZoom: 15,
                      batamBounds: LatLngBounds(
                        LatLng(0.91, 103.50),
                        LatLng(1.30, 104.20),
                      ),
                      selectedLocation: _bankLocation,
                      onLocationSelected: (_) {},
                    ),
                  ),

                  const SizedBox(height: 16),

                  WasteBankDetailCard(
                    name: widget.wasteBank.wasteBankName,
                    location: widget.wasteBank.wasteBankLocation,
                    imageUrl: widget.wasteBank.photo,
                  ),

                  SizedBox(height: 12),

                  CustomText(
                    "Tentang Bank Sampah",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),

                  SizedBox(height: 12),

                  CustomText(
                    "Bank Sampah Oke menerima berbagai jenis sampah organik seperti dun kering, sisa buah dan sisa sayur. Setiap sampah yang disetorkan akan ditimbang dan dicatat sebagai poin yang dapat ditukar barang kebutuhan sehari-hari.",
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _showConfirmDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB9F5C6),
                ),
                child: const CustomText(
                  "Setor Sampah",
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
