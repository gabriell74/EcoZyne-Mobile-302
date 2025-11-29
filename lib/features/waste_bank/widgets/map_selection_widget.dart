import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';

class MapSelectionWidget extends StatefulWidget {
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

  @override
  State<MapSelectionWidget> createState() => _MapSelectionWidgetState();
}

class _MapSelectionWidgetState extends State<MapSelectionWidget> {
  final GlobalKey<DragMarkerWidgetState> _markerKey = GlobalKey<DragMarkerWidgetState>();

  List<DragMarker> _buildMarkers() {
    if (widget.selectedLocation == null) return [];

    return [
      DragMarker(
        key: _markerKey,
        point: widget.selectedLocation!,
        size: const Size.square(50),
        offset: const Offset(0, -20),
        scrollMapNearEdge: true,
        scrollNearEdgeRatio: 2.0,
        scrollNearEdgeSpeed: 10.0,
        builder: (context, pos, isDragging) {
          print('Building marker - isDragging: $isDragging');
          return Icon(
            isDragging ? Icons.edit_location : Icons.location_on,
            color: Colors.red,
            size: 50,
          );
        },
        onDragEnd: (details, newPos) {
          widget.onLocationSelected(newPos);
          setState(() {});
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 320,
          child: FlutterMap(
            mapController: widget.mapController,
            options: MapOptions(
              initialCenter: widget.defaultCenter,
              initialZoom: widget.defaultZoom,
              minZoom: 4.0,
              maxZoom: 25.0,
              cameraConstraint:
              CameraConstraint.contain(bounds: widget.batamBounds),

              // Tambahkan interactionOptions untuk prioritas gesture
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),

              onTap: (tapPosition, point) { // Update signature
                if (widget.batamBounds.contains(point)) {
                  widget.onLocationSelected(point);
                  setState(() {});
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
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.ecozyne.mobile',
              ),
              DragMarkers(
                markers: _buildMarkers(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomText(
            "Pilih Lokasi di Peta",
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        if (widget.selectedLocation != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Latitude: ${widget.selectedLocation!.latitude.toStringAsFixed(6)}",
                  fontSize: 14,
                ),
                CustomText(
                  "Longitude: ${widget.selectedLocation!.longitude.toStringAsFixed(6)}",
                  fontSize: 14,
                ),
              ],
            ),
          ),
      ],
    );
  }
}