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
  double tempMax = max;
  double tempMin = min;

  void pickPath() async {
    String result = await FilePicker.platform.getDirectoryPath();
    setState(() {
      path = result;
    });
  }

  void toggleDynamic(bool value, BuildContext context) {
    setState(() {
      dyn = value;
    });
    if (!dyn) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Vertical Range"),
              content: Column(
                children: [
                  TextField(
                    controller: TextEditingController()..text = min.toString(),
                    keyboardType: TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    onChanged: (value) => tempMin = double.parse(value),
                    decoration: InputDecoration(labelText: "Minimum"),
                  ),
                  TextField(
                    controller: TextEditingController()..text = max.toString(),
                    keyboardType: TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    onChanged: (value) => tempMax = double.parse(value),
                    decoration: InputDecoration(labelText: "Maximum"),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      max = tempMax;
                      min = tempMin;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          });
    }
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
          SwitchListTile(
            title: Text("Dynamic Y-Axis"),
            secondary: Icon(
              Icons.height,
              size: 30,
            ),
            subtitle: Text("Keep vertical axis dynamic or specify range"),
            value: dyn,
            onChanged: (value) => toggleDynamic(value, context),
          ),
        ],
      ),
    );
  }
}
