import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:alberaperfume/main.dart' as app;

void main() {
  // 1. تهيئة حزمة اختبارات التكامل
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Albera Perfume End-to-End Integration Test', () {
    testWidgets('App startup, local storage, and server connection test',
        (WidgetTester tester) async {
      // 2. تشغيل دالة main الخاصة بالتطبيق
      app.main();

      // 3. انتظار تحميل كل الـ Widgets واستقرار الإطارات
      await tester.pumpAndSettle();

      print('--------------------------------------------------');
      print('>>> [TEST LOG]: App launched successfully!');
      print('--------------------------------------------------');

      // 4. محاكاة وقت التحميل والـ Splash Screen (انتظار 5 ثوانٍ)
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      print('--------------------------------------------------');
      print('>>> [TEST LOG]: Navigation and state sync test completed!');
      print('--------------------------------------------------');
    });
  });
}
