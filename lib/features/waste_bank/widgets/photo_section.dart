import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/image_picker_field.dart';
import 'dart:io';

class PhotoSection extends StatefulWidget {
  final Function(File? file) onImageSelected;
  final String? initialImagePath;

  const PhotoSection({
    super.key,
    required this.onImageSelected,
    this.initialImagePath,
  });

  @override
  State<PhotoSection> createState() => _PhotoSectionState();
}

class _PhotoSectionState extends State<PhotoSection> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.initialImagePath != null) {
      _selectedImage = File(widget.initialImagePath!);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            initialImage: _selectedImage,
            onImageSelected: (file) {
              setState(() {
                _selectedImage = file;
              });
              widget.onImageSelected(file);
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
}