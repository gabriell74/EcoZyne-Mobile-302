import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ecozyne_mobile/data/providers/auth_provider.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;

  const OtpVerifyScreen({
    super.key,
    required this.email,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
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
      context.read<AuthProvider>().resetOtpRateLimit();
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

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    final isResendDisabled =
        _resendSeconds > 0 ||
            authProvider.isResendOtpLoading ||
            authProvider.isResendOtpRateLimited;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: Color(0xFF55C173)),
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
                      Icons.email_outlined,
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
                    'Kode OTP telah dikirim ke',
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
                      onPressed: authProvider.isOtpLoading ||
                          authProvider.isOtpRateLimited
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

                        await authProvider.verifyOtp(
                          email: widget.email,
                          otp: otp,
                        );

                        if (!mounted) return;

                        if (authProvider.success == true) {
                          showSuccessTopSnackBar(
                            context,
                            authProvider.message ??
                                'Verifikasi berhasil',
                          );

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                                (_) => false,
                          );
                        } else {
                          showErrorTopSnackBar(
                            context,
                            authProvider.message ??
                                'Verifikasi gagal',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.grey[300],
                        elevation: 0,
                      ),
                      child: authProvider.isOtpLoading
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
                      await authProvider.resendOtp(
                        email: widget.email,
                      );

                      if (!mounted) return;

                      showSuccessTopSnackBar(
                        context,
                        authProvider.message ??
                            'OTP berhasil dikirim ulang',
                      );

                      _startResendTimer();
                    },
                    child: authProvider.isResendOtpLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
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

                  if (authProvider.isOtpRateLimited ||
                      authProvider.isResendOtpRateLimited) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomText(
                              'Terlalu banyak percobaan. Silakan coba lagi dalam 10 menit.',
                              color: Colors.red[700],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
