import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import '../data/variables.dart';
import 'package:file_picker/file_picker.dart';

class SettingsScreen extends StatefulWidget {
  static String routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  
  void pickPath() async {
    String result = await FilePicker.platform.getDirectoryPath();
    setState(() {
      path = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            // color: Colors.black,
            ),
        title: Text(
          'SmartEEG',
          // style: TextStyle(
          //   color: Colors.black,
          // ),
        ),
        // backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.file_copy_outlined,
              size: 30,
            ),
            title: Text("CSV Files Storage Path"),
            subtitle: Text(path),
            trailing: Icon(Icons.chevron_right),
            onTap: () => pickPath(),
          ),
        ],
      ),
    );
  }
}
