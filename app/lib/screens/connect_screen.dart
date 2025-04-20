import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../sendData.dart'; 

class ConnectScreen extends StatefulWidget {
  final BluetoothDevice device;

  const ConnectScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  bool isConnected = false;
  BLEService bleService = BLEService();
  String receivedData = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _connectToDevice() async {
    try {
      await bleService.connectToDevice(widget.device);
      setState(() {
        isConnected = true;
      });
    } catch (e) {
      print("Error connecting: $e");
    }
  }

  Future<void> _disconnectFromDevice() async {
    await bleService.disconnectFromDevice();
    setState(() {
      isConnected = false;
    });
  }

  Future<void> _sendData() async {
    try {
      List<String> received = await bleService.sendData("Test Messagesss");
      print("Data sent successfully");

      if (received.isNotEmpty) {
        print("Received echo: ${received.join()}");
        setState(() {
          receivedData = received.join();
        });

        
        _showDataReceivedDialog(received.join());
      } else {
        print("No data received from device.");
        setState(() {
          receivedData =
              "No data received from device."; 
        });

        _showDataReceivedDialog(
            "No data received from device."); 
      }
    } catch (e) {
      print("Error sending/receiving data: $e");
    }
  }

  void _showDataReceivedDialog(String data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Data Received"),
          content: Text("$data"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          height: 180,
          width: double.infinity,
          color: Colors.blue,
          child: const Center(
            child: Text(
              "Bluetooth App",
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
          key: isConnected ? Key('disconnect_button') : Key('connect_button'),
          onPressed: isConnected ? _disconnectFromDevice : _connectToDevice,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: isConnected ? Colors.red : Colors.blue,
            minimumSize: const Size(350, 55),
          ),
          child: Text(isConnected ? "Disconnect" : "Connect"),
        ),
        if (isConnected) ...[
          ElevatedButton(
            key: Key('send_data_key'),
            onPressed: _sendData, 
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green, 
              minimumSize: const Size(350, 55),
            ),
            child: const Text("Send Data"),
          ),
        ],
      ]),
    );
  }
}
