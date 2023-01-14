import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock/wakelock.dart';

import '../models/EEGData.dart';

import 'settings_screen.dart';
import 'signal_data_screen.dart';
import 'pairing_screen.dart';

const MethodChannel signalPlatform =
    MethodChannel("samples.flutter.dev/bluetooth");

class ElectrodesScreen extends StatefulWidget {
  static String routeName = '/heatmap';

  @override
  _ElectrodesScreenState createState() => _ElectrodesScreenState();
}

class _ElectrodesScreenState extends State<ElectrodesScreen> {
  String _outputString = 'Computing Impedance. Please wait...';
  double height = 30;
  double width = 180;
  List<double> _v = [0, 0, 0, 0, 0, 0, 0, 0];
  List<bool> _b = [false, false, false, false, false, false, false, false];
  List<EEGData> list = [];

  int count = 0;
  int counter = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Wakelock.enable();

    streamController.stream.listen((data) {
      count++;
      if (count >= 9) {
        list.add(data);
        if (counter == 100) {
          changeText();
          List<double> sumSq = [0, 0, 0, 0, 0, 0, 0, 0];
          for (EEGData item in list) {
            for (int i = 0; i < 8; i++) {
              sumSq[i] += pow(item.data[i] * 0.02235, 2);
              // print(item.data);
            }
          }
          List<bool> vals = [
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false
          ];
          for (int i = 0; i < 8; i++) {
            sumSq[i] = sqrt(sumSq[i] / 100) / 0.006;
            vals[i] = sumSq[i] < 7000;
          }
          list.removeAt(0);
          setState(() {
            _v = sumSq;
            _b = vals;
          });
        } else {
          counter += 1;
        }
        count = 0;
      }
    });
  }

  void changeText() {
    setState(() {
      _outputString = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          'Electrodes',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(SettingsScreen.routeName),
          ),
          IconButton(
            icon: Icon(
              Icons.check,
            ),
            onPressed: () async {
              if (_b[0] &&
                  _b[1] &&
                  _b[2] &&
                  _b[3] &&
                  _b[4] &&
                  _b[5] &&
                  _b[6] &&
                  _b[7]) {
                String recvMsg =
                    await signalPlatform.invokeMethod("sendSignal");
                if (recvMsg == "Signal Sent") {
                  Navigator.of(context).pushNamed(SignalDataScreen.routeName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    "Couldn't switch to EEG data signals",
                  )));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Electrodes aren't adjusted properly"),
                  action: SnackBarAction(
                      label: "IGNORE",
                      onPressed: () => Navigator.of(context)
                          .pushNamed(SignalDataScreen.routeName)),
                ));
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Adjust electrodes until their indicators turn green. Then tap the checkmark on the top right.",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              height: height,
              width: width,
              child: Row(
                children: [
                  Text("1"),
                  SizedBox(width: 10),
                  Icon(
                    Icons.fiber_manual_record_rounded,
                    color: _b[0] ? Colors.green : Colors.red,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(_v[0].toString()),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: height,
              width: width,
              child: Row(
                children: [
                  Text("2"),
                  SizedBox(width: 10),
                  Icon(
                    Icons.fiber_manual_record_rounded,
                    color: _b[1] ? Colors.green : Colors.red,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(_v[1].toString()),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: height,
              width: width,
              child: Row(
                children: [
                  Text("3"),
                  SizedBox(width: 10),
                  Icon(
                    Icons.fiber_manual_record_rounded,
                    color: _b[2] ? Colors.green : Colors.red,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(_v[2].toString()),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: height,
              width: width,
              child: Row(
                children: [
                  Text("4"),
                  SizedBox(width: 10),
                  Icon(
                    Icons.fiber_manual_record_rounded,
                    color: _b[3] ? Colors.green : Colors.red,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(_v[3].toString()),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: height,
              width: width,
              child: Row(
                children: [
                  Text("5"),
                  SizedBox(width: 10),
                  Icon(
                    Icons.fiber_manual_record_rounded,
                    color: _b[4] ? Colors.green : Colors.red,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(_v[4].toString()),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: height,
              width: width,
              child: Row(
                children: [
                  Text("6"),
                  SizedBox(width: 10),
                  Icon(
                    Icons.fiber_manual_record_rounded,
                    color: _b[5] ? Colors.green : Colors.red,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(_v[5].toString()),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: height,
              width: width,
              child: Row(
                children: [
                  Text("7"),
                  SizedBox(width: 10),
                  Icon(
                    Icons.fiber_manual_record_rounded,
                    color: _b[6] ? Colors.green : Colors.red,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(_v[6].toString()),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: height,
              width: width,
              child: Row(
                children: [
                  Text("8"),
                  SizedBox(width: 10),
                  Icon(
                    Icons.fiber_manual_record_rounded,
                    color: _b[7] ? Colors.green : Colors.red,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(_v[7].toString()),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text(_outputString),
            )
          ],
        ),
      ),
    );
  }
}
