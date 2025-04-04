import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:thesis_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Device compatibility testing", (WidgetTester tester) async {
    app.main();

    await tester.pumpAndSettle();

    final scanButton = find.byKey(Key('scan_button'));
    expect(scanButton, findsOneWidget);
    await tester.tap(scanButton);

    await tester.pumpAndSettle();

    await tester.pumpAndSettle();

    final device = find.byKey(Key('device_tile_Nordic_UART_Service'));
    expect(device, findsOneWidget);
    await tester.tap(device);

    await tester.pumpAndSettle();

    await tester.pumpAndSettle(const Duration(seconds: 5));

    final connectButton = find.byKey(Key('connect_button'));
    expect(connectButton, findsOneWidget);
    await tester.tap(connectButton);

    await tester.pumpAndSettle(const Duration(seconds: 5));

  });
}
