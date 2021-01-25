import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'heatmap_screen.dart';

class PairingScreen extends StatefulWidget {
  const PairingScreen({Key key}) : super(key: key);

  static String routeName = '/pairing';
  @override
  _PairingScreenState createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  static const MethodChannel platform =
      MethodChannel('samples.flutter.dev/bluetooth');

  List<String> _deviceList = <String>[];

  Future<void> _getDeviceList() async {
    var deviceList = <dynamic>[];
    try {
      deviceList = await platform.invokeMethod('getDeviceList');
    } on PlatformException catch (e) {
      deviceList.add("Failed to get device list: '${e.message}'.");
    }

    setState(() {
      _deviceList = (deviceList as List)?.map((dynamic item) => item as String)?.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SmartEEG',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Welcome',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(35, 100, 20, 8),
            child: Center(
              child: Text(
                'Please enter your device in pairing mode and connect using the button below.',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text('Connect to Device'),
              color: Colors.green,
              onPressed: _getDeviceList,
            ),
          ),
          for (String device in _deviceList)
            RaisedButton(
              child: Text(device),
              onPressed: () =>
                  Navigator.of(context).pushNamed(HeatmapScreen.routeName),
            ),
        ],
      ),
    );
  }
}
