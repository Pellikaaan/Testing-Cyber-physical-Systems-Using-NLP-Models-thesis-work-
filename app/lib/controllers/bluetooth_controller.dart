//https://www.youtube.com/watch?v=an4NbIjcXYI

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  var isScanning = false.obs;

  @override
  void onInit() {
    super.onInit();

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


  Future<void> scanDevices() async {
    if (isScanning.value) return;

    isScanning.value = true;

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10), androidUsesFineLocation: true);
    } catch (e) {
      print("Error during scan: $e");
    } finally {
      isScanning.value = false;
    }
  }

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}