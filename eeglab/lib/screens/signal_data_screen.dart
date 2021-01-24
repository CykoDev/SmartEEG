import 'dart:async';
import 'dart:math';

import 'package:eeglab/models/EEGData.dart';
import 'package:eeglab/widgets/MyChart.dart';
import 'package:flutter/material.dart';

class SignalDataScreen extends StatefulWidget {
  const SignalDataScreen({Key key}) : super(key: key);
  static String routeName = '/signal';

  @override
  _SignalDataScreenState createState() => _SignalDataScreenState();
}

class _SignalDataScreenState extends State<SignalDataScreen> {
  final StreamController<EEGData> streamController =
      StreamController.broadcast();

  final rand = Random();

  bool streamOn = false;

  final List<EEGData> _list = [];

  int counter = 0;

  List<Color> colors = [
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.blueGrey,
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.blueGrey,
  ];

  DateTime start;

  Future startStream() async {
    streamOn = true;
    start = DateTime.now();
    while (streamOn) {
      await Future<EEGData>.delayed(const Duration(milliseconds: 2));
      final time = DateTime.now().difference(start);
      final timeString = (time.inMinutes % 60).toString() +
          ':' +
          (time.inSeconds % 60).toString() +
          ':' +
          (time.inMilliseconds % 1000).toString();
      streamController.add(EEGData(timeString, [
        rand.nextDouble(),
        rand.nextDouble(),
        rand.nextDouble(),
        rand.nextDouble(),
        rand.nextDouble(),
        rand.nextDouble(),
        rand.nextDouble(),
        rand.nextDouble()
      ]));
    }
  }

  @override
  void initState() {
    super.initState();
    streamController.stream.listen((data) {
      counter++;
      if (counter >= 9) {
        setState(() {
          _list.add(data);
          if (_list.length > 100) {
            _list.removeAt(0);
          }
        });
        counter = 0;
      }
    });
    startStream();
  }

  @override
  void dispose() {
    streamOn = false;
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'SmartEEG',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Container(
            height: 50,
            child: MyChart(_list, 0, false, '1', colors[0]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 1, false, '2', colors[1]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 2, false, '3', colors[2]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 3, false, '4', colors[3]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 4, false, '5', colors[4]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 5, false, '6', colors[5]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 6, false, '7', colors[6]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 0, false, '1', colors[7]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 1, false, '2', colors[8]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 2, false, '3', colors[9]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 3, false, '4', colors[10]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 4, false, '5', colors[12]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 5, false, '6', colors[13]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 6, false, '7', colors[14]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, 6, false, '7', colors[15]),
          ),
          Container(
            height: 75,
            child: MyChart(_list, 7, true, '8', colors[11]),
          ),
        ],
      ),
    );
  }
}
