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
            child: MyChart(_list, channel: 0, channelName: '1', color: colors[0], dyn: false),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 1, channelName: '2', color: colors[1]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 2, channelName: '3', color: colors[2]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 3, channelName: '4', color: colors[3]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 4, channelName: '5', color: colors[4]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 5, channelName: '6', color: colors[5]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 6, channelName: '7', color: colors[6]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 0, channelName: '1', color: colors[7]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 1, channelName: '2', color: colors[8]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 2, channelName: '3', color: colors[9]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 3, channelName: '4', color: colors[10]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 4, channelName: '5', color: colors[12]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 5, channelName: '6', color: colors[13]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 6, channelName: '7', color: colors[14]),
          ),
          Container(
            height: 50,
            child: MyChart(_list, channel: 6, channelName: '7', color: colors[15]),
          ),
          Container(
            height: 75,
            child: MyChart(_list, channel: 7, xAxis: true, channelName: '8', color: colors[11]),
          ),
        ],
      ),
    );
  }
}
