import 'package:flutter/material.dart';
import 'package:thesis_app/controllers/bluetooth_controller.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BluetoothController> (
        init: BluetoothController(),
        builder:(controller) {
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
                  child: ElevatedButton(onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(350, 55),
                  ),
                  child: Text(
                    "Scan",
                    style: TextStyle(fontSize: 18),
                  )
                  )
                )
              ],
              ),
          );
        }),
     );
  }
}