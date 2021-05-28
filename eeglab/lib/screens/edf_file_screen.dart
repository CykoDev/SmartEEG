import 'package:eeglab/data/variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EDFFileScreen extends StatefulWidget {
  @override
  _EDFFileScreenState createState() => _EDFFileScreenState();
}

class _EDFFileScreenState extends State<EDFFileScreen> {
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
        title: Text("File: " + openedFileName),
      ),
      body: Center(
        child: Container(
          child: Text(openedFile.path),
        ),
      ),
    );
  }
}
