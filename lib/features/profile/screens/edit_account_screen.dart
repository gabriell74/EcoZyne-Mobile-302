import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/models/region.dart';
import 'package:ecozyne_mobile/data/models/user.dart';
import 'package:ecozyne_mobile/data/providers/region_provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:provider/provider.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _whatsappNumController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _postalCodeController;

  Kecamatan? _selectedKecamatan;
  Kelurahan? _selectedKelurahan;

  Future<void> _saveProfile(
      BuildContext context,
      User user, {
        required String username,
        required String name,
        required String phoneNumber,
        required String email,
        required String address,
        required int kelurahanId,
        required String postalCode,
      }) async {

    if (_formKey.currentState!.validate()) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (confirmDialogContext) =>
            ConfirmationDialog(
              "Apakah anda yakin mengubah data profil?",
              onTap: () => Navigator.pop(confirmDialogContext, true),
            ),
      );

      if (confirmed != true) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (loadingContext) => const LoadingWidget(height: 100),
      );

      final userProvider = context.read<UserProvider>();

      final success = await userProvider.updateUserProfile(
        username: username,
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        address: address,
        kelurahanId: kelurahanId,
        postalCode: postalCode,
      );

      if (context.mounted) Navigator.pop(context);

      if (success) {
        showSuccessTopSnackBar(
          context,
          "Profil berhasil diperbarui",
          icon: const Icon(Icons.check_circle),
        );

        Navigator.pop(context);
      } else {
        showErrorTopSnackBar(
          context,
          userProvider.message,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    User? user = context.read<UserProvider>().user;

    _usernameController = TextEditingController(text: user!.username);
    _nameController = TextEditingController(text: user.communityName);
    _emailController = TextEditingController(text: user.email);
    _whatsappNumController = TextEditingController(text: user.communityPhone);
    _addressController = TextEditingController(text: user.communityAddress);
    _postalCodeController = TextEditingController(text: user.communityPostalCode);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final regionProvider = context.read<RegionProvider>();

      if (regionProvider.kecamatanList.isEmpty) {
        await regionProvider.loadRegions();
      }

      _selectedKecamatan = regionProvider.kecamatanList.firstWhere(
            (k) => k.kecamatan == user.communityKecamatan,
        orElse: () => regionProvider.kecamatanList.first,
      );

      _selectedKelurahan = regionProvider.kelurahanList.firstWhere(
            (kel) => kel.kelurahan == user.communityKelurahan,
        orElse: () => regionProvider.kelurahanList.first,
      );

      setState(() {});
    });

  }


  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _whatsappNumController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regionProvider = Provider.of<RegionProvider>(context);
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          'Edit Akun',
          color: Colors.black, fontWeight: FontWeight.bold,
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
            CustomText(
              user!.username,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            CustomText("${user.communityPoint} Poin", fontSize: 14, color: Colors.grey),
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
                    _whatsappNumController,
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
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField<Kecamatan>(
                          label: "Kecamatan",
                          value: _selectedKecamatan,
                          items: regionProvider.kecamatanList
                              .map(
                                (k) => DropdownMenuItem(
                              value: k,
                              child: CustomText(k.kecamatan, textOverflow: TextOverflow.ellipsis),
                            ),
                          )
                              .toList(),
                          onChanged: (k) {
                            setState(() {
                              _selectedKecamatan = k;
                              _selectedKelurahan = null;
                            });
                            regionProvider.selectKecamatan(k);
                          },
                          validator: (v) => v == null ? "Pilih Kecamatan" : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _selectedKecamatan == null
                            ? const Text("Pilih Kecamatan dulu")
                            : _buildDropdownField<Kelurahan>(
                          label: "Kelurahan",
                          value: _selectedKelurahan,
                          items: regionProvider.kelurahanList
                              .map(
                                (kel) => DropdownMenuItem(
                              value: kel,
                              child: CustomText(kel.kelurahan, textOverflow: TextOverflow.ellipsis),
                            ),
                          )
                              .toList(),
                          onChanged: (kel) => setState(() => _selectedKelurahan = kel),
                          validator: (v) => v == null ? "Pilih Kelurahan" : null,
                        ),

                      ),
                    ],
                  ),
                  _buildTextField(
                    'Kode pos',
                    _postalCodeController,
                    keyboardType: TextInputType.number,
                    validator: Validators.postalCode,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        _saveProfile(
                          context,
                          user,
                          username: _usernameController.text,
                          name: _nameController.text,
                          phoneNumber: _whatsappNumController.text,
                          email: _emailController.text,
                          address: _addressController.text,
                          kelurahanId: _selectedKelurahan!.id,
                          postalCode: _postalCodeController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF55C173),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const CustomText(
                        'Simpan',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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

Widget _buildDropdownField<T>({
  required String label,
  required T? value,
  required List<DropdownMenuItem<T>> items,
  required void Function(T?) onChanged,
  String? Function(T?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
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
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
    ),
  );
}

