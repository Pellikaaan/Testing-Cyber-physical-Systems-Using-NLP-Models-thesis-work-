import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:thesis_app/main.dart' as app;
import 'helpers/device_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Device stability testing, connect/disconnect repeatidly.", (WidgetTester tester) async {
    await navigateToDevice(tester);

// Will loop through 10 times and try reconnecting (connecting & disconnecting)
    for (int i=0; i<11; i++) {

        final connectButton = find.byKey(Key('connect_button'));
        final disconnectButton = find.byKey(Key('disconnect_button'));

        if (connectButton.evaluate().isNotEmpty) {
            expect(connectButton, findsOneWidget);
            await tester.tap(connectButton);

            await tester.pumpAndSettle(const Duration(seconds: 5));
        }
      
        if (disconnectButton.evaluate().isNotEmpty) {
            expect(disconnectButton, findsOneWidget);
            await tester.tap(disconnectButton);

            await tester.pumpAndSettle(const Duration(seconds: 5));
        }
      } 

    await tester.pumpAndSettle(const Duration(seconds: 5));

  });

/*
  testWidgets("Device stability testing, bluetooth connection lost.", (WidgetTester tester) async {
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

  testWidgets("Device stability testing, device out of range.", (WidgetTester tester) async {
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
  */
}
