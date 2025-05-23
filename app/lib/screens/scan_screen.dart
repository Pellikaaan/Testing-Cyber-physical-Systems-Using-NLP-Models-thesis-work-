import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:thesis_app/controllers/bluetooth_controller.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:thesis_app/screens/bluetooth_off_screen.dart';
import 'package:thesis_app/screens/connect_screen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BluetoothController> (
        init: BluetoothController(),
        builder:(controller) {
          return FutureBuilder<BluetoothAdapterState>(
            future: FlutterBluePlus.adapterState.first,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != BluetoothAdapterState.on) {
                return BluetoothOffScreen(adapterState: snapshot.data!);
              }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.blue,
                  child: const Center(
                    child: Text("Bluetooth App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton(key: Key('scan_button'),
                    onPressed: () => controller.scanDevices(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(350, 55),
                  ),
                  child: Obx(() {
                    return controller.isScanning.value ? Text("Scanning..") : const Text("Scan");
                  }),
                  ),
                ),
                const SizedBox(height: 20),

                StreamBuilder<List<ScanResult>>(
                  stream: controller.scanResults,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          children: [CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text("Scanning for devices...", style: TextStyle(fontSize: 16)),
                          ])
                      );
                    }

                    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Column(
                          children: [
                          SizedBox(height: 10),
                          Text("No devices found.", style: TextStyle(fontSize: 16)),
                        ])
                      );
                    }

                    
                    final results = snapshot.data!;           

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: results.length,
                      itemBuilder: (context, index){
                        final data = results[index];
                        return Card(
                          elevation: 2,
                          child: 
                            ListTile(
                                key: Key('device_tile_${data.device.platformName}'),
                                title: Text(data.device.platformName),
                                subtitle: Text(data.device.remoteId.toString()),
                                trailing: Text(data.rssi.toString()),
                                onTap: () {
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ConnectScreen(device: data.device),
                                            ),
                                          );
                                        },
                                      ),
                              );
                            });
                        }
                    ),
                  ],
                ),
              );
            },
          );
        }
      )
    );
  }
}