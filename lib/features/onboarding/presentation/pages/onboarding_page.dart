import 'package:alberaperfume/features/onboarding/presentation/widgets/onboarding_page_body.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});
  static const String routeName = 'onBoarding';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          body: OnboardingPageBody(
            onPageChanged: (index) {
              // Handle page change if needed
            },
          )),
    );
  }
}
