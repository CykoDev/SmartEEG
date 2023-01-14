import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'pairing_screen.dart';
import 'csv_file_screen.dart';
import 'edf_file_screen.dart';
import '../data/variables.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  static String routeName = '/home';
  String _outputString = 'File Format';

  void edf2csv() async {

    final edf_content = await openedFile.readAsString();
    
    final response = await http.post(
      Uri.https('smart-eeg.herokuapp.com', 'conversion/edftocsv'),
      body: edf_content,
    );

    int code = response.statusCode;
    print(code);

    _outputString = response.body;

    String pathOfTheFileToWrite = path + tmpConversionFileName;
    File tmpfile = new File(pathOfTheFileToWrite);

    tmpfile.writeAsString(_outputString);

    openedFile = File(tmpfile.path);
    openedFileName = tmpConversionFileName;
  }

  void bdf2csv() async {

    final bdf_content = await openedFile.readAsString();
    
    final response = await http.post(
      Uri.https('smart-eeg.herokuapp.com', 'conversion/bdftocsv'),
      body: bdf_content,
    );

    int code = response.statusCode;
    print(code);

    _outputString = response.body;

    String pathOfTheFileToWrite = path + tmpConversionFileName;
    File tmpfile = new File(pathOfTheFileToWrite);

    tmpfile.writeAsString(_outputString);

    openedFile = File(tmpfile.path);
    openedFileName = tmpConversionFileName;
  }

  

  void pickFile(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'csv',
        'edf',
        'bdf',
        // 'xdf',
      ],
    );
    if (result != null) {
      PlatformFile file = result.files.single;
      openedFile = File(file.path);
      openedFileName = file.name;
      if (file.extension == 'csv') {
        Navigator.of(context).pushNamed(CSVFileScreen.routeName);
      } 
      else if (file.extension == 'edf') {
        edf2csv();
        Navigator.of(context).pushNamed(CSVFileScreen.routeName);
      }
      else if (file.extension == 'bdf') {
        bdf2csv();
        Navigator.of(context).pushNamed(CSVFileScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartEEG'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Connect to Headset',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Icon(
                                Icons.bluetooth,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () => Navigator.of(context)
                        .pushNamed(PairingScreen.routeName),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Import Data from File',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '(CSV  |  EDF / BDF / XDF)',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Icon(
                                Icons.file_present,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () => pickFile(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
