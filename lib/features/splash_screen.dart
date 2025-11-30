import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/no_connection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startFlow();
    });
  }

  Future<void> _startFlow() async {
    final userProvider = context.read<UserProvider>();

    await userProvider.fetchCurrentUser();

    if (!mounted) return;

    // Tidak ada koneksi
    if (userProvider.message == "NO_CONNECTION") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (screenContext) => NoConnectionScreen(
            onRetry: () {
              screenContext.read<UserProvider>().fetchCurrentUser();
            },
          ),
        ),
      );
      return;
    }

    // Token tidak ada -> Guest Mode
    if (userProvider.user == null && userProvider.isGuest) {
      Navigator.pushReplacementNamed(context, '/get_started');
      return;
    }

    // Token invalid -> Login
    if (userProvider.isGuest &&
        userProvider.message.contains("Token tidak valid")) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // User valid -> Masuk Get Started
    Navigator.pushReplacementNamed(context, '/get_started');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF55C173),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 100,
                height: 300,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              const CustomText(
                "Ecozyne",
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
