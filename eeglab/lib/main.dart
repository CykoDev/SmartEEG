import 'package:flutter/material.dart';

import 'screens/channel_data_screen.dart';
import 'screens/electrodes_screen.dart';
import 'screens/pairing_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signal_data_screen.dart';
import 'screens/home_screen.dart';
import 'screens/csv_file_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartEEG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        CSVFileScreen.routeName: (ctx) => CSVFileScreen(),
        ElectrodesScreen.routeName: (ctx) => ElectrodesScreen(),
        PairingScreen.routeName: (ctx) => PairingScreen(),
        SettingsScreen.routeName: (ctx) => SettingsScreen(),
        SignalDataScreen.routeName: (ctx) => SignalDataScreen(),
      },
    );
  }
}
