import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'pairing_screen.dart';
import 'csv_file_screen.dart';
import '../data/variables.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = '/home';

  void pickFile(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'csv',
        // 'edf',
        // 'bdf',
        // 'xdf',
      ],
    );
    if (result != null) {
      PlatformFile file = result.files.single;
      openedFile = File(file.path);
      openedFileName = file.name;
      Navigator.of(context).pushNamed(CSVFileScreen.routeName);
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
