import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';

class MapSelectionWidget extends StatelessWidget {
  final MapController mapController;
  final LatLng defaultCenter;
  final double defaultZoom;
  final LatLngBounds batamBounds;
  final LatLng? selectedLocation;
  final Function(LatLng) onLocationSelected;

  const MapSelectionWidget({
    super.key,
    required this.mapController,
    required this.defaultCenter,
    required this.defaultZoom,
    required this.batamBounds,
    required this.selectedLocation,
    required this.onLocationSelected,
  });

  MarkerLayer _buildMarkerLayer() {
    return MarkerLayer(
      markers: [
        Marker(
          point: selectedLocation!,
          width: 60,
          height: 60,
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 350,
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: defaultCenter,
              initialZoom: defaultZoom,
              minZoom: 4.0,
              maxZoom: 25.0,
              cameraConstraint: CameraConstraint.contain(bounds: batamBounds),
              onTap: (_, point) {
                if (batamBounds.contains(point)) {
                  onLocationSelected(point);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const CustomText(
                        'Pilih lokasi di dalam area Batam',
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.ecozyne.mobile',
              ),
              if (selectedLocation != null) _buildMarkerLayer(),
            ],
          ),
        ),
      ],
    );
  }

}