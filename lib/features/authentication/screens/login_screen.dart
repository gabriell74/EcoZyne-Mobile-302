import 'package:ecozyne_mobile/core/widgets/animated_gradient_text.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/floating_logo.dart';
import 'package:ecozyne_mobile/data/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

                const SizedBox(height: 30),

                // email
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
                const SizedBox(height: 15),

                // password
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscure,
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

                SizedBox(height: screenSize.height * 0.12),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      final email = _emailController.text;
                      final password = _passwordController.text;

                      final isValid = authProvider.validateEmailPassword(email, password);
                    },
                    child: const CustomText(
                      "Masuk Akun",
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
                      "Belum Punya Akun? ",
                      color: Colors.grey.shade500,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const CustomText(
                        "Daftar",
                        color: Color(0xFF649B71),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
