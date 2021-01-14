import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
