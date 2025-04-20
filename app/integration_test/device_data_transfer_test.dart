import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:thesis_app/main.dart' as app;
import 'helpers/device_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Device Data Transfer testing", (WidgetTester tester) async {
    await navigateToDevice(tester);

    final connectButton = find.byKey(Key('connect_button'));
    await tester.tap(connectButton);
    await tester.pumpAndSettle();

    final sendDataButton = find.byKey(Key('send_data_key'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(sendDataButton, findsOneWidget);

    await tester.tap(sendDataButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final dialog = find.byType(AlertDialog);
    expect(dialog, findsOneWidget); 

    final dataText = find.descendant(of: dialog, matching: find.text('Data Received'));
    expect(dataText, findsOneWidget); 

    final contentText = find.descendant(of: dialog, matching: find.text('Test Messagesss'));
    expect(contentText, findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });
}
