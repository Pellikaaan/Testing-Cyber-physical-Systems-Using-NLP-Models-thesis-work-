import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLETestService {
  final String deviceName = "Nordic_UART_Service";
  final Guid nusRxUuid = Guid("6e400002-b5a3-f393-e0a9-e50e24dcca9e");
  final Guid nusTxUuid = Guid("6e400003-b5a3-f393-e0a9-e50e24dcca9e");

  Future<void> testBleWriteRead() async {
    print("Starting BLE test...");

    // Start scanning
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    // Find device
    BluetoothDevice? targetDevice;
    await for (ScanResult result in FlutterBluePlus.scanResults) {
      for (var r in result) {
        if (r.device.platformName.contains(deviceName)) {
          targetDevice = r.device;
          break;
        }
      }
      if (targetDevice != null) break;
    }

    FlutterBluePlus.stopScan();
    if (targetDevice == null) {
      print("Device not found");
      return;
    }

    // Connect to device
    await targetDevice.connect();
    print("Connected to ${targetDevice.platformName}");

    // Discover services
    List<BluetoothService> services = await targetDevice.discoverServices();
    late BluetoothCharacteristic rxChar;
    late BluetoothCharacteristic txChar;

    for (var service in services) {
      for (var char in service.characteristics) {
        if (char.uuid == nusRxUuid) {
          rxChar = char;
        }
        if (char.uuid == nusTxUuid) {
          txChar = char;
        }
      }
    }

    // Start listening to notifications
    List<String> receivedData = [];

    await txChar.setNotifyValue(true);
    txChar.onValueReceived.listen((value) {
      try {
        String decoded = String.fromCharCodes(value);
        print("Received: $decoded");
        receivedData.add(decoded);
      } catch (e) {
        print("Failed to decode: $value");
      }
    });

    // Send data
    final testData = "Test Message\n";
    await rxChar.write(testData.codeUnits);
    print("Sent: $testData");

    // Wait for notification
    await Future.delayed(Duration(seconds: 10));

    // Validate
    if (receivedData.isEmpty) {
      print("No data received from BLE device!");
    } else if (!receivedData.first.contains("Test Message")) {
      print("Incorrect data received: ${receivedData.first}");
    } else {
      print("BLE test passed!");
    }

    // Cleanup
    await txChar.setNotifyValue(false);
    await targetDevice.disconnect();
  }
}