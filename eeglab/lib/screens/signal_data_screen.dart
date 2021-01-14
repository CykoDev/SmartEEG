import 'dart:math';

import 'package:eeglab/models/linear_sales.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SignalDataScreen extends StatefulWidget {
  SignalDataScreen({Key key}) : super(key: key);
  static String routeName = '/signal';

  @override
  _SignalDataScreenState createState() => _SignalDataScreenState();
}

class _SignalDataScreenState extends State<SignalDataScreen> {
  final List<LinearSales> _list = <LinearSales>[];

  final rand = Random();

  bool streamOn = false;

  int i = 0;

  LinearSales stream() {
    return LinearSales(i, rand.nextDouble() * 1000);
  }

  Future startStream() async {
    streamOn = true;
    while (streamOn) {
      await Future<LinearSales>.delayed(const Duration(milliseconds: 2));
      setState(() {
        _list.add(stream());
        if (_list.length > 100) {
          _list.removeAt(0);
        }
        i++;
      });
    }
  }

  @override
  void initState() {
    startStream();
    super.initState();
  }

  @override
  void dispose() {
    streamOn = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: new Text(
          'SmartEEG',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SfCartesianChart(
          title: ChartTitle(text: 'Example Live Data'),
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries>[
            LineSeries<LinearSales, int>(
                enableTooltip: true,
                dataSource: _list,
                xValueMapper: (LinearSales sales, _) => sales.year,
                yValueMapper: (LinearSales sales, _) => sales.sales)
          ],
        ),
      ),
    );
  }
}
