import 'dart:async';
import 'dart:math';

import 'package:eeglab/models/EEGData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'pairing_screen.dart';

class ChannelDataScreen extends StatefulWidget {
  const ChannelDataScreen(this.channel, {Key key}) : super(key: key);

  static const String routeName = '/channel';
  final int channel;

  @override
  _ChannelDataScreenState createState() => _ChannelDataScreenState();
}

class _ChannelDataScreenState extends State<ChannelDataScreen> {
  final rand = Random();

  bool streamOn = false;

  final List<EEGData> _list = [];

  int counter = 0;

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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries>[
            LineSeries<EEGData, String>(
                enableTooltip: true,
                dataSource: _list,
                xValueMapper: (EEGData data, _) => data.time,
                yValueMapper: (EEGData data, _) => data.data[widget.channel])
          ],
        ),
      ),
    );
  }
}
