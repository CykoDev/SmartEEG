import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'settings_screen.dart';
import 'signal_data_screen.dart';

class HeatmapScreen extends StatefulWidget {
  static String routeName = '/heatmap';

  @override
  _HeatmapScreenState createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  String _outputString = 'File Format';

  void fetchCSV() async {
    final response = await http.post(
      Uri.https('smart-eeg.herokuapp.com', 'conversion/edftocsv2'),
      body: "testString",
    );

    int code = response.statusCode;
    print(code);

    _outputString = response.body;
  }

  void changeState() async {
    // final scaffold = Scaffold.of(context);
    // scaffold.showSnackBar(
    //   SnackBar(
    //     content: const Text('Getting data, please wait'),
    //     action: SnackBarAction(
    //         label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
    //   ),
    // );
    setState(() {
      _outputString = "Fetching data...";
    });
    await fetchCSV();
    setState(() {
      _outputString = _outputString;
    });
    // scaffold.showSnackBar(
    //   SnackBar(
    //     content: const Text('Data received!'),
    //     action: SnackBarAction(
    //         label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          'SmartEEG',
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
              Icons.show_chart,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(SignalDataScreen.routeName),
          ),
        ],
      ),
      body: Column(
        children: [
          Text(
            _outputString,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          RaisedButton(
            child: Text('Get Data'),
            onPressed: changeState,
          ),
        ],
      ),
    );
  }
}
