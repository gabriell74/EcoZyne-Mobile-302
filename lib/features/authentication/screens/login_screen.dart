import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:ecozyne_mobile/core/widgets/animated_gradient_text.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/floating_logo.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/auth_provider.dart';
import 'package:ecozyne_mobile/data/providers/navigation_provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

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

  Future<bool> handleLogin(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();

    // 1️⃣ Login
    final loginSuccess = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!context.mounted) return false;

    if (loginSuccess) {
      await userProvider.fetchCurrentUser();

      Navigator.pushReplacementNamed(context, AppRoutes.home);

      Future.delayed(const Duration(milliseconds: 300), () {
        showSuccessTopSnackBar(
          context,
          "Selamat datang, ${userProvider.user?.username ?? "Guest"}!",
          icon: const Icon(Icons.waving_hand),
        );
      });

      return true;
    } else {
      showErrorTopSnackBar(
        context,
        authProvider.message ?? "Login gagal, periksa kembali data Anda.",
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final authProvider = context.watch<AuthProvider>();
    final navProvider = context.read<NavigationProvider>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white.withValues(alpha: 0.1)),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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

                const SizedBox(height: 30),

                // Email
                TextFormField(
                  controller: _emailController,
                  validator: Validators.email,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Password
                TextFormField(
                  controller: _passwordController,
                  validator: Validators.password,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                      icon: Icon(
                        Icons.remove_red_eye_rounded,
                        color: _isObscure ? Colors.grey : Color(0xFF649B71),
                      ),
                    ),
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
                    onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await handleLogin(context);
                          }
                          navProvider.setIndex(0);
                        },
                    child: authProvider.isLoading
                      ? const LoadingWidget()
                      : const CustomText(
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
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const CustomText(
                        "Daftar",
                        color: Color(0xFF55C173),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
