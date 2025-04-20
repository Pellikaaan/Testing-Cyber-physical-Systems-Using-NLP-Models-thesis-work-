import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

class BLEService {
  final String deviceName = "Nordic_UART_Service";
  final Guid nusRxUuid = Guid("6e400002-b5a3-f393-e0a9-e50e24dcca9e");
  final Guid nusTxUuid = Guid("6e400003-b5a3-f393-e0a9-e50e24dcca9e");

  BluetoothDevice? device;
  bool isConnected = false;
  List<BluetoothService> services = [];

  Future<void> connectToDevice(BluetoothDevice targetDevice) async {
    try {
      await targetDevice.connect();
      device = targetDevice;
      isConnected = true;
      services = await targetDevice.discoverServices();
    } catch (e) {
      throw Exception("Error connecting to device: $e");
    }
  }

  Future<void> disconnectFromDevice() async {
    if (device != null) {
      await device!.disconnect();
      isConnected = false;
      services.clear();
    }
  }

  Future<List<String>> sendData(String data) async {
  if (device == null) throw Exception("Device not connected");

  BluetoothCharacteristic? rxChar;
  BluetoothCharacteristic? txChar;

  for (var service in services) {
    for (var char in service.characteristics) {
      if (char.uuid == nusRxUuid) rxChar = char;
      if (char.uuid == nusTxUuid) txChar = char;
    }
  }

  if (rxChar == null || txChar == null) {
    throw Exception("Required characteristics not found");
  }

  await txChar.setNotifyValue(true);

  final completer = Completer<List<String>>();
  List<String> receivedData = [];

  late final StreamSubscription<List<int>> subscription;
  subscription = txChar.onValueReceived.listen((value) async {
    try {
      String decoded = String.fromCharCodes(value);
      receivedData.add(decoded);

      await subscription.cancel();
      completer.complete(receivedData);
    } catch (e) {
      completer.completeError("Failed to decode received data: $e");
    }
  });

  await rxChar.write(data.codeUnits);

  return completer.future.timeout(
    Duration(seconds: 5),
    onTimeout: () {
      subscription.cancel();
      throw Exception("Timed out waiting for response from device.");
    },
  );
}
}