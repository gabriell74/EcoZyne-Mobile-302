import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class WasteBankRegisterState {
  final bankName = TextEditingController();
  final address = TextEditingController();
  final rt = TextEditingController();
  final rw = TextEditingController();
  final whatsapp = TextEditingController();
  final description = TextEditingController();
  final postalCode = TextEditingController();

  LatLng? selectedLocation;
  String? imagePath;
  String? pdfPath;

  void dispose() {
    bankName.dispose();
    address.dispose();
    rt.dispose();
    rw.dispose();
    whatsapp.dispose();
    description.dispose();
    postalCode.dispose();
  }

  bool get hasLocation => selectedLocation != null;
  bool get hasImage => imagePath != null;
  bool get hasPdf => pdfPath != null;
}
