import 'package:flutter/material.dart';

class EEGFileScreen extends StatelessWidget {
  static String routeName = '/eeg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV Data'),
      ),
      body: Container(
        child: Center(
          child: Text("EEG Data will be shown here"),
        ),
      ),
    );
  }
}
