import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  static const MethodChannel platform =
      MethodChannel('samples.flutter.dev/bluetooth');

  List<String> _deviceList = <String>[];

  Future<void> _getDeviceList() async {
    var deviceList = <String>[];
    try {
      deviceList = await platform.invokeMethod('getDeviceList');
    } on PlatformException catch (e) {
      deviceList.add("Failed to get device list: '${e.message}'.");
    }

    setState(() {
      _deviceList = deviceList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: const Text('Get Device List'),
              onPressed: _getDeviceList,
            ),
            for (String device in _deviceList) Text(device),
          ],
        ),
      ),
    );
  }
}
