import 'package:flutter/material.dart';

class CSVFileScreen extends StatelessWidget {
  static String routeName = '/csv';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV Data'),
      ),
      body: Container(
        child: Center(
          child: Text("CSV Data will be shown here"),
        ),
      ),
    );
  }
}
