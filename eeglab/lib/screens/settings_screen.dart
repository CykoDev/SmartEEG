import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import '../data/variables.dart';

class SettingsScreen extends StatelessWidget {
  static String routeName = '/settings';

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
      body: SettingsList(
        sections: [
          SettingsSection(
            // title: 'Section',
            tiles: [
              SettingsTile.switchTile(
                title: 'Impedance',
                leading: Icon(
                  Icons.fingerprint,
                ),
                switchValue: true,
                onToggle: (bool value) {},
              ),
              SettingsTile.switchTile(
                title: 'Use fingerprint',
                leading: Icon(
                  Icons.fingerprint,
                ),
                switchValue: true,
                onToggle: (bool value) {},
              ),
              SettingsTile.switchTile(
                title: 'Use fingerprint',
                leading: Icon(
                  Icons.fingerprint,
                ),
                switchValue: true,
                onToggle: (bool value) {},
              ),
              SettingsTile(
                title: 'CSV Files Storage Path',
                subtitle: path,
                leading: Icon(
                  Icons.file_copy_outlined,
                ),
                onTap: () {},
              ),
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(
                  Icons.language,
                ),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
