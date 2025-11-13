import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/utils/validators.dart'; // ⬅️ manggil file validator

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      showSuccessTopSnackBar(
        context,
        "Data berhasil diperbarui",
        icon: const Icon(Icons.save_alt, size: 28),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Akun',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: const Color(0xFFEEEEEE),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Color(0xFF55C173),
              ),
            ),
            const SizedBox(height: 10),
            const CustomText(
              'Keisha Cantik',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            const CustomText('2000 Poin', fontSize: 14, color: Colors.grey),
            const SizedBox(height: 25),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    'Nama Pengguna',
                    _usernameController,
                    validator: Validators.username,
                  ),
                  _buildTextField(
                    'Nama Asli',
                    _nameController,
                    validator: Validators.name,
                  ),
                  _buildTextField(
                    'No HP',
                    _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: Validators.whatsapp,
                  ),
                  _buildTextField(
                    'Email',
                    _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  _buildTextField(
                    'Alamat',
                    _addressController,
                    maxLines: 2,
                    validator: Validators.address,
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: screenSize.width * 0.4,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF55C173),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Focus(
        child: Builder(
          builder: (context) {
            final isFocused = Focus.of(context).hasFocus;
            return TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              validator: validator,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: isFocused ? const Color(0xFF55C173) : Colors.grey,
                  fontWeight: isFocused ? FontWeight.w600 : FontWeight.normal,
                ),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF55C173),
                    width: 1.8,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
