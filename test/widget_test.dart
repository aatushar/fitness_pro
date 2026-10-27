import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_pro/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FitnessProApp());
    await tester.pump(const Duration(seconds: 1));
    // Basic test - just verify app builds without error
    expect(find.byType(FitnessProApp), findsOneWidget);
  });
}
