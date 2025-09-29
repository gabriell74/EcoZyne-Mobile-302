import 'package:ecozyne_mobile/data/providers/auth_provider.dart';
import 'package:ecozyne_mobile/data/providers/navigation_provider.dart';
import 'package:ecozyne_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: EcoApp(),
    ),
  );
}

class EcoApp extends StatelessWidget {
  const EcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoZyne',
      theme: AppTheme.lightTheme,
<<<<<<< HEAD
      initialRoute: AppRoutes.home,
=======
      initialRoute: AppRoutes.articles,
>>>>>>> ed20cb4809e7f953de2ef32ebf77314bcc94adbd
      routes: AppRoutes.routes,
    );
  }
}
