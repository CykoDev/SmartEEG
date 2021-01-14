import 'package:flutter/material.dart';

import 'heatmap_screen.dart';

class PairingScreen extends StatelessWidget {
  static String routeName = '/pairing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SmartEEG',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Welcome',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(35, 100, 20, 8),
            child: Center(
              child: Text(
                'Please enter your device in pairing mode and connect using the button below.',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text('Connect to Device'),
              color: Colors.green,
              onPressed: () =>
                  Navigator.of(context).pushNamed(HeatmapScreen.routeName),
            ),
          ),
        ],
      ),
    );
  }
}
