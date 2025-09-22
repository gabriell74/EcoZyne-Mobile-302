import 'package:ecozyne_mobile/core/widgets/animated_gradient_text.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/floating_logo.dart';
import 'package:ecozyne_mobile/data/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _userNameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _whatsappNumController;
  late TextEditingController _addressController;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _whatsappNumController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _whatsappNumController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final AuthProvider authProvider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.1),
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenSize.height * 0.08),
              SizedBox(
                width: screenSize.width * 0.25,
                child: FloatingLogo(),
              ),
              const SizedBox(height: 5),

              AnimatedGradientText(
                "Ecozyne",
                colors: [
                  Colors.green,
                  Colors.blue
                ],
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),

              const SizedBox(height:25),

              // Name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Nama Pengguna",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Username
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  hintText: "Nama Asli",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Email
              TextField(
                controller: _emailController,
                onChanged: authProvider.validateEmail,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: "Email",
                  errorText: authProvider.emailError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Password
              TextField(
                controller: _passwordController,
                obscureText: _isObscure,
                onChanged: authProvider.validatePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(onPressed: () => setState(() => _isObscure = !_isObscure ),
                      icon: Icon(CupertinoIcons.eye_slash_fill)),
                  errorText: authProvider.passwordError,
                  hintText: "Kata Sandi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // WhatsApp Number
              TextField(
                controller: _whatsappNumController,
                decoration: InputDecoration(
                  hintText: "No WhatsApp",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Nama Pengguna",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Name
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: "Alamat",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              Row(
                children: [
                  DropdownMenuFormField(
                    label: const Text("Kecamatan"),
                    dropdownMenuEntries: ["A", "B", "C"].map((e) {
                      return DropdownMenuEntry(value: e, label: e);
                    }).toList(),
                  ),
                  DropdownMenuFormField(
                    label: const Text("Kelurahan"),
                    dropdownMenuEntries: ["A", "B", "C"].map((e) {
                      return DropdownMenuEntry(value: e, label: e);
                    }).toList(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
