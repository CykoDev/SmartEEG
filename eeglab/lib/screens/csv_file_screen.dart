import 'dart:async';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:eeglab/data/variables.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import '../data/variables.dart';
import '../models/EEGData.dart';
import '../widgets/CSVChart.dart';

class CSVFileScreen extends StatefulWidget {
  static String routeName = '/csv';

  @override
  _CSVFileScreenState createState() => _CSVFileScreenState();
}

class _CSVFileScreenState extends State<CSVFileScreen> {
  List<EEGData> _list = [];
  final double chartHeight = 150;
  final double spaceHeight = 30;
  // List<EEGData> list2 = [];
  // List<EEGData> list3 = [];
  // List<EEGData> list4 = [];
  // List<EEGData> list5 = [];
  // List<EEGData> list6 = [];
  // List<EEGData> list7 = [];
  // List<EEGData> list8 = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readCsv();
  }

  void readCsv() async {
    final input = openedFile.openRead();
    List<List<dynamic>> fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    int count = 0;
    List<EEGData> list = [];
    for (List<dynamic> field in fields) {
      List<double> fieldDouble;
      try {
        fieldDouble = List<double>.from(field);
      } catch (e) {
        // final fieldInt = List<int>.from(field);
        fieldDouble = field.map<double>((dynamic e) => double.parse(e.toString())).toList();
        // fieldDouble = field;
      }
      // fieldDouble = List<double>.from(field);
      // final fieldDouble = fieldInt.map((e) => e.toDouble()).toList();
      list.add(EEGData(count.toString(), fieldDouble));
      count += 1;
      // list2.add(double.parse(field[1].toString()), count);
      // list3.add(double.parse(field[2].toString()), count);
      // list4.add(double.parse(field[3].toString()), count);
      // list5.add(double.parse(field[4].toString()), count);
      // list6.add(double.parse(field[5].toString()), count);
      // list7.add(double.parse(field[6].toString()), count);
      // list8.add(double.parse(field[7].toString()), count);
    }

    setState(() {
      _list = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File: " + openedFileName),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Text(openedFileName),
          Container(
            height: chartHeight,
            child: CSVChart(
              channel: 0,
              channelName: '1',
              list: _list,
            ),
          ),
          SizedBox(height: spaceHeight),
          Container(
            height: chartHeight,
            child: CSVChart(
              channel: 1,
              channelName: '2',
              list: _list,
            ),
          ),
          SizedBox(height: spaceHeight),
          Container(
            height: chartHeight,
            child: CSVChart(
              channel: 2,
              channelName: '3',
              list: _list,
            ),
          ),
          SizedBox(height: spaceHeight),
          Container(
            height: chartHeight,
            child: CSVChart(
              channel: 3,
              channelName: '4',
              list: _list,
            ),
          ),
          SizedBox(height: spaceHeight),
          Container(
            height: chartHeight,
            child: CSVChart(
              channel: 4,
              channelName: '5',
              list: _list,
            ),
          ),
          SizedBox(height: spaceHeight),
          Container(
            height: chartHeight,
            child: CSVChart(
              channel: 5,
              channelName: '6',
              list: _list,
            ),
          ),
          SizedBox(height: spaceHeight),
          Container(
            height: chartHeight,
            child: CSVChart(
              channel: 6,
              channelName: '7',
              list: _list,
            ),
          ),
          SizedBox(height: spaceHeight),
          Container(
            height: chartHeight,
            child: CSVChart(
              channel: 7,
              channelName: '8',
              list: _list,
            ),
          ),
        ],
      ),
    );
  }
}
