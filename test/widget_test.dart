import 'package:flutter_test/flutter_test.dart';
import 'package:alberaperfume/app/app.dart';

void main() {
  testWidgets('Albera app renders', (tester) async {
    await tester.pumpWidget(const AlberaApp());
    expect(find.text('ALBERA'), findsOneWidget);
  });
}
