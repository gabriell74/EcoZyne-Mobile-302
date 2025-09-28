import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:ecozyne_mobile/core/widgets/animated_gradient_text.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/floating_logo.dart';
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

  bool _isObscure = true;
  String? _selectedKecamatan;
  String? _selectedKelurahan;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _whatsappNumController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _whatsappNumController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

                // Username
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "Nama Pengguna",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                            Validators.username(v),
                      ),
                    ),

                    const SizedBox(width: 15),

                    // Nama asli
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Nama",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                            Validators.name(v),
                      ),
                    ),],
                ),
                const SizedBox(height: 15),



                // Email
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.email,
                ),
                const SizedBox(height: 15),

                // Password
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    hintText: "Kata Sandi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                      icon: Icon(
                        Icons.remove_red_eye_rounded,
                        color: _isObscure ? Colors.grey : Color(0xFF649B71),
                      ),
                    ),
                  ),
                  validator: Validators.password,
                ),
                const SizedBox(height: 15),

                // WhatsApp
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _whatsappNumController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "No WhatsApp",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.whatsapp,
                ),
                const SizedBox(height: 15),

                // Alamat
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: "Alamat",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) =>
                      Validators.address(v),
                ),
                const SizedBox(height: 15),

                // Kecamatan & Kelurahan
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: _selectedKecamatan,
                        decoration: const InputDecoration(
                          labelText: "Kecamatan",
                          border: OutlineInputBorder(),
                        ),
                        items: ["A", "B", "C"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedKecamatan = value),
                        validator: (v) => v == null ? "Pilih Kecamatan" : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: _selectedKelurahan,
                        decoration: const InputDecoration(
                          labelText: "Kelurahan",
                          border: OutlineInputBorder(),
                        ),
                        items: ["A", "B", "C"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedKelurahan = value),
                        validator: (v) => v == null ? "Pilih Kelurahan" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.validate();
                    },
                    child: const CustomText(
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const CustomText(
                        "Login",
                        color: Color(0xFF649B71),
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
