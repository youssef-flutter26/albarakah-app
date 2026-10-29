import 'package:alberaperfume/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/onboarding_page_body.dart';
// استبدل المسار التالي بمسار شاشة الهوم الحقيقي لديك
// import '../../home/presentation/pages/home_page.dart';

class CustomPage extends StatelessWidget {
  const CustomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton(
              onPressed: () {
                // الانتقال للـ Home مباشرة عند الضغط على Skip

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LoginPage(), // استبدل HomePage باسم شاشتك الفعلية
                  ),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: AppTheme.gold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: OnboardingPageBody(
        onPageChanged: (index) {},
      ),
    );
  }
}
