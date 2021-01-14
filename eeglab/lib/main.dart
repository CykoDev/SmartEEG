import 'package:flutter/material.dart';

import 'screens/heatmap_screen.dart';
import 'screens/pairing_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signal_data_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartEEG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PairingScreen(),
      routes: {
        HeatmapScreen.routeName: (ctx) => HeatmapScreen(),
        PairingScreen.routeName: (ctx) => PairingScreen(),
        SettingsScreen.routeName: (ctx) => SettingsScreen(),
        SignalDataScreen.routeName: (ctx) => SignalDataScreen(),
      },
    );
  }
}
