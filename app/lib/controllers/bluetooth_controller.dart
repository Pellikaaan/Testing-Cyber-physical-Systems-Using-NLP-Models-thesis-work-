//https://www.youtube.com/watch?v=an4NbIjcXYI

import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  var isScanning = false.obs;
  var isConnected = false.obs;
  var connectedDeviceName = "".obs;
  final File logFile = File("ble_logs.txt");
  DateTime? connectionStartTime;
  String get platformType => Platform.isAndroid? "Android" : "iOS";

  @override
  void onInit() {
    super.onInit();

/*
    FlutterBluePlus.scanResults.listen((results) {
      if (results.isEmpty) {
        print("No devices found during scan.");
      } else {
        for (var result in results) {
          print("Found device: ${result.device.platformName}, RSSI: ${result.rssi}");
        }
      }
    });
  }
*/

// Add log output to text file, for the test file to be able to read info about scanning
    FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        String logEntry = "[$platformType] Device name: ${result.device.platformName}. RSSI: ${result.rssi}\n";
        logFile.writeAsStringSync(logEntry, mode: FileMode.append);
        print(logEntry);
      }
    });

//Log connections and disconnections in text file for the test file to be able to read info about connections
  FlutterBluePlus.connectedDevices.listen((devices) {

      if (devices.isNotEmpty) {
        isConnected.value = true;
        connectedDeviceName.value = devices.first.platformName;
        connectionStartTime = DateTime.now();
        String timestampConnect = connectionStartTime!.toIso8601String();
        String logEntry = "[$platformType][$timestampConnect] Connected to: ${devices.first.platformName}\n";
        logFile.writeAsStringSync(logEntry, mode: FileMode.append);
        print(logEntry);
      } else {
        isConnected.value = false;

        if (connectionStartTime != null) {
          DateTime timestampDisconnect = DateTime.now();
          double connectionDuration = timestampDisconnect.difference(connectionStartTime!).inSeconds.toDouble();
          String logEntry = "[$platformType][$timestampDisconnect] Disconnected. Connection duration: ${connectionDuration} seconds\n";
          logFile.writeAsStringSync(logEntry, mode: FileMode.append);
          print(logEntry);

          connectionStartTime = null;
        } else {
          logFile.writeAsStringSync("[$platformType] Disconnected (No previous connection recorded).\n", mode: FileMode.append);
          print("Disconnected (No previous connection recorded).");
      }
      }
    }
  );
}

  Future<void> scanDevices() async {
    if (isScanning.value) return;

    isScanning.value = true;

    try {
      logFile.writeAsStringSync("Scanning started...\n", mode: FileMode.append);
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10), androidUsesFineLocation: true);
    } catch (e) {
      String errorLog = "Scan error: $e\n";
      logFile.writeAsStringSync(errorLog, mode: FileMode.append);
      print("Error during scan: $e");
    } finally {
      isScanning.value = false;
      logFile.writeAsStringSync("Scanning finished.\n", mode: FileMode.append);
      print("Scanning finished.");
    }
  }

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}