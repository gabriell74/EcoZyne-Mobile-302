import 'dart:async';
import 'package:ecozyne_mobile/features/authentication/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ecozyne_mobile/data/providers/forgot_password_provider.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordOtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState
    extends State<ForgotPasswordOtpScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  Timer? _resendTimer;
  int _resendSeconds = 180;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ForgotPasswordProvider>().resetOtpRateLimit();
      _startResendTimer();
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = 180);

    _resendTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_resendSeconds == 0) {
            timer.cancel();
          } else {
            setState(() => _resendSeconds--);
          }
        });
  }

  String getOtpCode() {
    return _otpControllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    final forgotProvider = context.watch<ForgotPasswordProvider>();
    final theme = Theme.of(context);

    final isResendDisabled =
        _resendSeconds > 0 ||
            forgotProvider.isResendOtpLoading ||
            forgotProvider.isResendOtpRateLimited;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_reset_outlined,
                      size: 50,
                      color: theme.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 32),

                  const CustomText(
                    'Verifikasi OTP',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),

                  const SizedBox(height: 12),

                  CustomText(
                    'Kode OTP untuk reset password telah dikirim ke',
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    widget.email,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF55C173),
                  ),

                  const SizedBox(height: 48),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50,
                        height: 60,
                        child: TextFormField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: theme.primaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (v) {
                            if (v.isNotEmpty && index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            }
                            if (v.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                          },
                          validator: (v) =>
                          v == null || v.isEmpty ? '' : null,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 48),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: forgotProvider.isOtpLoading ||
                          forgotProvider.isOtpRateLimited
                          ? null
                          : () async {
                        FocusScope.of(context).unfocus();

                        if (!_formKey.currentState!.validate()) return;

                        final otp = getOtpCode();
                        if (otp.length != 6) {
                          showErrorTopSnackBar(
                            context,
                            'Mohon lengkapi semua digit OTP',
                          );
                          return;
                        }

                        await forgotProvider.verifyOtp(
                          email: widget.email,
                          otp: otp,
                        );

                        if (!mounted) return;

                        if (forgotProvider.success == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPasswordScreen(email: widget.email),
                              )
                          );
                          showSuccessTopSnackBar(
                            context,
                            forgotProvider.message ?? 'OTP valid',
                          );
                        } else {
                          showErrorTopSnackBar(
                            context,
                            forgotProvider.message ??
                                'Verifikasi OTP gagal',
                          );
                        }
                      },
                      child: forgotProvider.isOtpLoading
                          ? const LoadingWidget()
                          : const CustomText(
                        'Verifikasi',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextButton(
                    onPressed: isResendDisabled
                        ? null
                        : () async {
                      await forgotProvider.resendResetPasswordOtp(
                        email: widget.email,
                      );

                      if (!mounted) return;

                      if (forgotProvider.isResendOtpRateLimited) {
                        showErrorTopSnackBar(
                          context,
                          forgotProvider.message ??
                              'Terlalu banyak percobaan',
                        );
                        return;
                      }

                      showSuccessTopSnackBar(
                        context,
                        forgotProvider.message ??
                            'Kode OTP dikirim ulang',
                      );

                      _startResendTimer();
                    },
                    child: forgotProvider.isResendOtpLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: LoadingWidget(height: 400, width: 400,),
                    )
                        : CustomText(
                      _resendSeconds > 0
                          ? 'Kirim ulang OTP (${_resendSeconds ~/ 60}:${(_resendSeconds % 60).toString().padLeft(2, '0')})'
                          : 'Kirim ulang OTP',
                      color: isResendDisabled
                          ? Colors.grey
                          : const Color(0xFF55C173),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}