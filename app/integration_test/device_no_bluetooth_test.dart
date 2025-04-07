import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:thesis_app/main.dart' as app;
import 'helpers/device_test_helpers.dart';

// Manually turn off bluetooth first to test this!

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Bluetooth off testing", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final enableBTButton = find.byKey(Key('enable_BT_button'));
    expect(enableBTButton, findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 5));

  });
}
