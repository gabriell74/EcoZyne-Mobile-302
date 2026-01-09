import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:ecozyne_mobile/core/widgets/animated_gradient_text.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/floating_logo.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/forgot_password_provider.dart';
import 'package:ecozyne_mobile/features/authentication/screens/forgot_password_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
    context.read<ForgotPasswordProvider>();

    final success = await provider.sendResetPasswordOtp(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordOtpScreen(email: _emailController.text.trim()),
        )
      );
      showSuccessTopSnackBar(context, "OTP Berhasil Dikirim");
    } else {
      showErrorTopSnackBar(context, provider.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Consumer<ForgotPasswordProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white.withValues(alpha: 0.1),
          ),
          body: AppBackground(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
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
                      "Lupa Kata Sandi",
                      colors: [Colors.green, Colors.blue],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    CustomText(
                      "Masukkan email terdaftar untuk menerima kode OTP",
                      color: Colors.grey.shade500,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    TextFormField(
                      controller: _emailController,
                      validator: Validators.emailLogin,
                      autovalidateMode:
                      AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon:
                        const Icon(Icons.email_outlined),
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(height: screenSize.height * 0.12),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : _handleSendEmail,
                        child: provider.isLoading
                            ? const LoadingWidget()
                            : const CustomText(
                          "Kirim Kode OTP",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const CustomText(
                        "Kembali ke Login",
                        color: Color(0xFF55C173),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
