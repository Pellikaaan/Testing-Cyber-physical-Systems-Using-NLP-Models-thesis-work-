import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:thesis_app/main.dart' as app;
import 'helpers/device_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Device compatibility testing", (WidgetTester tester) async {
    await navigateToDevice(tester);

    final connectButton = find.byKey(Key('connect_button'));
    expect(connectButton, findsOneWidget);
    await tester.tap(connectButton);

    await tester.pumpAndSettle(const Duration(seconds: 5));

  });
}
