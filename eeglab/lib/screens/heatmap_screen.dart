import 'package:flutter/material.dart';

import 'settings_screen.dart';
import 'signal_data_screen.dart';

class HeatmapScreen extends StatelessWidget {
  static String routeName = '/heatmap';

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
      body: Center(
        child: new Text(
          'File Format',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
