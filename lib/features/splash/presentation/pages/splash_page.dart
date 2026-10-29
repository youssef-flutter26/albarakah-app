import 'package:alberaperfume/features/splash/presentation/widgets/splash_page_body.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  static const String routeName = 'splash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashViewBody());
  }
}
