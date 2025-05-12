import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:thesis_app/main.dart' as app;

Future<void> navigateToDevice(WidgetTester tester) async {
  app.main();

  await tester.pumpAndSettle();

  final scanButton = find.byKey(Key('scan_button'));
  expect(scanButton, findsOneWidget);
  await tester.tap(scanButton);

  await tester.pumpAndSettle(const Duration(seconds: 10));

  await tester.pumpAndSettle();

  final device = find.byKey(Key('device_tile_Nordic_UART_Service'));
  await tester.ensureVisible(device);
  expect(device, findsOneWidget);
  await tester.tap(device);

  await tester.pumpAndSettle();

  await tester.pumpAndSettle(const Duration(seconds: 5));

}
