import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectScreen extends StatefulWidget {
  final BluetoothDevice device;

  const ConnectScreen({Key? key, required this.device}): super(key: key);

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  bool isConnected = false;
  List<BluetoothService> services= [];

  @override
  void initState() {
    super.initState();
    _connectToDevice();
    }
  

  Future<void> _connectToDevice() async {
    try {
      await widget.device.connect();
      isConnected = true;

      services = await widget.device.discoverServices();
      setState(() {});
    }  catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _disconnectToDevice() async {
    await widget.device.disconnect();
    setState(() {
      isConnected = false;
      services.clear();
    });
  }

  @override
  Widget build(BuildContext context) {

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

          Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              title: Text("Device name: ${widget.device.platformName}"),
              subtitle: Text("Device ID: ${widget.device.remoteId}"),
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
          onPressed: isConnected ? _disconnectToDevice : _connectToDevice,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: isConnected ? Colors.red : Colors.blue,
            minimumSize: const Size(350, 55),
          ),
          child: Text(isConnected ? "Disconnect" : "Connect"),
        )
      ]),
    );
  }
}