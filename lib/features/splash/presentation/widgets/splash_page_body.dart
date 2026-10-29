import 'package:alberaperfume/core/constants/app_constants.dart';
import 'package:alberaperfume/core/storage/shared_pref.dart';
import 'package:alberaperfume/core/theme/app_theme.dart';
import 'package:alberaperfume/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:alberaperfume/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:provider/provider.dart';

import '../../../../core/storage/local_storage.dart';
import '../../../home/presentation/home_page.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // إعداد الـ Animation لتأثير ظهور تدريجي وتكبير هادئ (Zoom & Fade)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    excuteNavigation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.ink, AppTheme.gold],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/zafreon.jpg',
                      height: 380,
                      width: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // اسم التطبيق بتصميم راقي
                const Text(
                  'Albarakah Perfume',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.5,
                    color: Color(0xFF3D2314),
                  ),
                ),
                const SizedBox(height: 8),
                // جملة تعريفية قصيرة تزيد من فخامة الواجهة
                const Text(
                  'The Essence of Elegance',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    color: Color(0xFF8C7A6B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void excuteNavigation() {
    bool isOnBoardingSeen = SharedPref.getBool(AppConstants.isOnBoardingSeen);
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      if (isOnBoardingSeen) {
        var isLoggedIn = context.read<LocalStorage>().isLoggedIn();
        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardingPage()),
        );
      }
    });
  }
}
