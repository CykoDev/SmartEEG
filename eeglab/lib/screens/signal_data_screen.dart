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

  Future startStream() async {
    streamOn = true;
    while (streamOn) {
      await Future<EEGData>.delayed(const Duration(milliseconds: 2));
      streamController.add(EEGData(DateTime.now(), [
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(child: MyChart(_list, 0)),
            Expanded(child: MyChart(_list, 1)),
            Expanded(child: MyChart(_list, 2)),
            Expanded(child: MyChart(_list, 3)),
            Expanded(child: MyChart(_list, 4)),
            Expanded(child: MyChart(_list, 5)),
            Expanded(child: MyChart(_list, 6)),
            Expanded(child: MyChart(_list, 7)),
          ],
        ),
      ),
    );
  }
}
