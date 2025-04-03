// https://www.youtube.com/watch?v=an4NbIjcXYI

import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  var isScanning = false.obs;
  var isConnected = false.obs;
  var connectedDeviceName = "".obs;
  final File logFile = File("ble_logs.txt");
  DateTime? connectionStartTime;
  String get platformType => Platform.isAndroid ? "Android" : "iOS";

  @override
  void onInit() {
    super.onInit();

    FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        String logEntry = "[$platformType] Device name: ${result.device.platformName}. RSSI: ${result.rssi}\n";
        logFile.writeAsString(logEntry, mode: FileMode.append);
        print(logEntry);
      }
    });

    connectedDeviceStream.listen((devices) {
      if (devices.isNotEmpty) {
        // Device connected
        final device = devices.first;
        if (!isConnected.value) {
          isConnected.value = true;
          connectedDeviceName.value = device.platformName;
          connectionStartTime = DateTime.now();
          String timestampConnect = connectionStartTime!.toIso8601String();
          String logEntry = "[$platformType][$timestampConnect] Connected to: ${device.platformName}\n";
          logFile.writeAsString(logEntry, mode: FileMode.append);
          print(logEntry);
        }
      } else {
        // Device disconnected
        if (isConnected.value) {
          isConnected.value = false;

          if (connectionStartTime != null) {
            DateTime timestampDisconnect = DateTime.now();
            double connectionDuration = timestampDisconnect.difference(connectionStartTime!).inSeconds.toDouble();
            String logEntry = "[$platformType][$timestampDisconnect] Disconnected. Connection duration: ${connectionDuration} seconds\n";
            logFile.writeAsString(logEntry, mode: FileMode.append);
            print(logEntry);

            connectionStartTime = null;
          } else {
            logFile.writeAsString("[$platformType] Disconnected (No previous connection recorded).\n", mode: FileMode.append);
            print("Disconnected (No previous connection recorded).");
          }
        }
      }
    });
  }

  Stream<List<BluetoothDevice>> get connectedDeviceStream async* {
    while (true) {
      final devices = await FlutterBluePlus.connectedDevices;
      yield devices;
      await Future.delayed(Duration(seconds: 5));
    }
  }

  // Scan for BLE devices
  Future<void> scanDevices() async {
    if (isScanning.value) return;

    isScanning.value = true;

    try {
      print("Running Start scan.");
      logFile.writeAsString("Scanning started...\n", mode: FileMode.append);
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
        androidUsesFineLocation: true,
      );
    } catch (e) {
      String errorLog = "Scan error: $e\n";
      logFile.writeAsString(errorLog, mode: FileMode.append);
      print("Error during scan: $e");
    } finally {
      isScanning.value = false;
      logFile.writeAsString("Scanning finished.\n", mode: FileMode.append);
      print("Scanning finished.");
    }
  }

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}
