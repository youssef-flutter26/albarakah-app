import 'package:alberaperfume/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class AlberaApp extends StatelessWidget {
  const AlberaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Albarakah Perfume',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashPage(),
    );
  }
}
