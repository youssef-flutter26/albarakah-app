import 'package:alberaperfume/core/constants/app_constants.dart';
import 'package:alberaperfume/core/storage/shared_pref.dart';
import 'package:alberaperfume/features/auth/presentation/pages/login_page.dart';
import 'package:alberaperfume/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'custom_page_item.dart';

class OnboardingPageBody extends StatefulWidget {
  const OnboardingPageBody({super.key, required this.onPageChanged});

  final ValueChanged<int> onPageChanged;

  @override
  State<OnboardingPageBody> createState() => _OnboardingPageBodyState();
}

class _OnboardingPageBodyState extends State<OnboardingPageBody> {
  late PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
              widget.onPageChanged(index);
            },
            children: const [
              CustomPageItem(
                title: "Exquisite Oriental & Western Perfumes",
                subtitle:
                    "Discover an exclusive collection of the finest perfumes tailored for your refined taste.",
                image: 'assets/images/zafreon2.jpg',
              ),
              CustomPageItem(
                title: "Long-Lasting Fragrance",
                subtitle:
                    "100% original perfumes that give you an overwhelming presence and confidence everywhere.",
                image: "assets/images/ELarisse3.jpg",
              ),
              CustomPageItem(
                title: 'Fast & Secure Delivery',
                subtitle:
                    "Order now and enjoy a seamless shopping experience with fast delivery to your doorstep.",
                image: 'assets/images/ELarisse.jpg',
              ),
            ],
          ),
        ),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: currentIndex == index ? 24 : 8,
              decoration: BoxDecoration(
                color: currentIndex == index ? AppTheme.gold : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Next / Get Started Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (currentIndex < 2) {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // 1. حفظ حالة الـ Onboarding بأن المستخدم تخطاها
                  SharedPref.setBool(AppConstants.isOnBoardingSeen, true);

                  // 2. الانتقال إلى شاشة الـ Login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                }
              },
              child: Text(
                currentIndex == 2 ? "Get Started" : "Next",
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
