import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:ecozyne_mobile/core/widgets/animated_gradient_text.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/floating_logo.dart';
import 'package:ecozyne_mobile/data/models/region.dart';
import 'package:ecozyne_mobile/data/providers/auth_provider.dart';
import 'package:ecozyne_mobile/data/providers/region_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _whatsappNumController;
  late TextEditingController _addressController;
  late TextEditingController _postalCodeController;

  bool _isObscure = true;
  Kecamatan? _selectedKecamatan;
  Kelurahan? _selectedKelurahan;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _whatsappNumController = TextEditingController();
    _addressController = TextEditingController();
    _postalCodeController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RegionProvider>(context, listen: false).loadRegions();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _whatsappNumController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regionProvider = Provider.of<RegionProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.08),
                SizedBox(width: screenSize.width * 0.25, child: FloatingLogo()),
                const SizedBox(height: 5),

                AnimatedGradientText(
                  "Ecozyne",
                  colors: [Colors.green, Colors.blue],
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                // Username & Nama
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _usernameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: "Nama Pengguna",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorText: Validators.validationError('username')
                        ),
                        validator: Validators.username,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: "Nama",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorText: Validators.validationError('nama')
                        ),
                        validator: Validators.name,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Email
                TextFormField(
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: Validators.validationError('email')
                  ),
                  validator: Validators.email,
                  onChanged: (_) => Validators.clearFieldError('email'),
                ),
                const SizedBox(height: 15),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: "Kata Sandi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: Validators.validationError('password'),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye_rounded,
                        color: _isObscure ? Colors.grey : const Color(0xFF649B71),
                      ),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                  ),
                  validator: Validators.password,
                ),
                const SizedBox(height: 15),

                // WhatsApp
                TextFormField(
                  controller: _whatsappNumController,
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: "No WhatsApp",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  errorText: Validators.validationError('phone_number')
                  ),
                  validator: Validators.whatsapp,
                ),
                const SizedBox(height: 15),

                // Alamat
                TextFormField(
                  controller: _addressController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: "Alamat",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: Validators.validationError('address')
                  ),
                  validator: Validators.address,
                ),
                const SizedBox(height: 15),

                // Postal Code
                TextFormField(
                  controller: _postalCodeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Kode Pos",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: Validators.validationError('postal_code')
                  ),
                  validator: Validators.postalCode,
                ),
                const SizedBox(height: 15),

                // Kecamatan & Kelurahan
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Kecamatan>(
                        decoration: const InputDecoration(
                          labelText: "Kecamatan",
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _selectedKecamatan,
                        isExpanded: true,
                        items: regionProvider.kecamatanList
                            .map((kec) => DropdownMenuItem<Kecamatan>(
                          value: kec,
                          child: Text(kec.kecamatan, overflow: TextOverflow.ellipsis),
                        ))
                            .toList(),
                        onChanged: (kec) {
                          setState(() {
                            _selectedKecamatan = kec;
                            _selectedKelurahan = null;
                          });
                          regionProvider.selectKecamatan(kec);
                        },
                        validator: (v) => v == null ? "Pilih Kecamatan" : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _selectedKecamatan == null
                          ? const Text("Pilih Kecamatan dulu")
                          : DropdownButtonFormField<Kelurahan>(
                        decoration: const InputDecoration(
                          labelText: "Kelurahan",
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _selectedKelurahan,
                        isExpanded: true,
                        items: regionProvider.kelurahanList
                            .map((kel) => DropdownMenuItem<Kelurahan>(
                          value: kel,
                          child: Text(kel.kelurahan, overflow: TextOverflow.ellipsis),
                        ))
                            .toList(),
                        onChanged: (kel) => setState(() => _selectedKelurahan = kel),
                        validator: (v) => v == null ? "Pilih Kelurahan" : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Tombol Daftar
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedKecamatan == null || _selectedKelurahan == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pilih kecamatan & kelurahan')),
                          );
                          return;
                        }

                        await authProvider.register(
                          username: _usernameController.text,
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          phoneNumber: _whatsappNumController.text,
                          address: _addressController.text,
                          postalCode: _postalCodeController.text,
                          kecamatanId: _selectedKecamatan!.id,
                          kelurahanId: _selectedKelurahan!.id,
                        );

                        if (!mounted) return;

                        final message = authProvider.message;

                        if (authProvider.success == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: CustomText(message as String, color: Colors.red),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              backgroundColor: Colors.white,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const CustomText(
                                'Pendaftaran berhasil! Silakan login.',
                                color: Colors.green,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Colors.white,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );

                          if (!mounted) return;
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: authProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const CustomText(
                      "Daftar Akun",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      "Sudah Punya Akun? ",
                      color: Colors.grey.shade500,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const CustomText(
                        "Login",
                        color: Color(0xFF55C173),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
