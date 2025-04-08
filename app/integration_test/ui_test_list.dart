import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:thesis_app/main.dart' as app;
import 'helpers/device_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("UI testing, list.", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final scanButton = find.byKey(Key('scan_button'));
    await tester.tap(scanButton);

    expect(find.byType(ListTile), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 5));

  });
}
