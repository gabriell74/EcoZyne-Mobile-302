import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/map_selection_widget.dart';

class MapSection extends StatelessWidget {
  final MapController mapController;
  final LatLng defaultCenter;
  final double defaultZoom;
  final LatLngBounds batamBounds;
  final LatLng? selectedLocation;
  final Function(LatLng location) onLocationSelected;
  final Function()? onFetchAddress;

  const MapSection({
    super.key,
    required this.mapController,
    required this.defaultCenter,
    required this.defaultZoom,
    required this.batamBounds,
    required this.selectedLocation,
    required this.onLocationSelected,
    this.onFetchAddress,
  });

  @override
  Widget build(BuildContext context) {
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
            mapController: mapController,
            defaultCenter: defaultCenter,
            defaultZoom: defaultZoom,
            batamBounds: batamBounds,
            selectedLocation: selectedLocation,
            onLocationSelected: (loc) {
              onLocationSelected(loc);
              onFetchAddress?.call();
            },
          ),
          const SizedBox(height: 12),
          if (selectedLocation != null) ...[
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
                        selectedLocation!.latitude.toStringAsFixed(6),
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
                        selectedLocation!.longitude.toStringAsFixed(6),
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
}