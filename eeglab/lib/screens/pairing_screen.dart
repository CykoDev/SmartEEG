import 'dart:async';

import 'package:eeglab/models/EEGData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'heatmap_screen.dart';

const EventChannel _stream = EventChannel('bluetoothDataStream');
const MethodChannel platform = MethodChannel('samples.flutter.dev/bluetooth');
final StreamController<EEGData> streamController = StreamController.broadcast();

T cast<T>(dynamic x) => x is T ? x : null;

class PairingScreen extends StatefulWidget {
  const PairingScreen({Key key}) : super(key: key);

  static String routeName = '/pairing';
  @override
  _PairingScreenState createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  List<String> _deviceList = <String>[];

  Future<void> _getDeviceList() async {
    final start = DateTime.now();

    _stream.receiveBroadcastStream().listen((dynamic data) {
      final time = DateTime.now().difference(start);
      final timeString = (time.inMinutes % 60).toString() +
          ':' +
          (time.inSeconds % 60).toString() +
          ':' +
          (time.inMilliseconds % 1000).toString();

      final dataString = cast<String>(data);
      final eegData = <double>[];

      for (final s in dataString.split(',')) {
        eegData.add(double.parse(s));
      }

      streamController.add(EEGData(timeString, eegData));
    });

    var deviceList = <dynamic>[];
    try {
      deviceList = await platform.invokeMethod('getDeviceList');
    } on PlatformException catch (e) {
      deviceList.add("Failed to get device list: '${e.message}'.");
    }

    setState(() {
      _deviceList = deviceList?.map((dynamic item) => item as String)?.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SmartEEG',
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Welcome',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(35, 100, 20, 8),
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
              child: const Text('Connect to Device'),
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
