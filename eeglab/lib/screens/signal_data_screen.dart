import 'dart:math';
import 'dart:io';
import 'package:eeglab/models/EEGData.dart';
import 'package:eeglab/widgets/MyChart.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'pairing_screen.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:simple_permissions/simple_permissions.dart';


class SignalDataScreen extends StatefulWidget {
  const SignalDataScreen({Key key}) : super(key: key);
  static String routeName = '/signal';

  @override
  _SignalDataScreenState createState() => _SignalDataScreenState();
}

class _SignalDataScreenState extends State<SignalDataScreen> {
  final rand = Random();

  bool streamOn = false;

  final List<EEGData> _list = [];

  int counter = 0;

  List<Color> colors = [
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.blueGrey,
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.blueGrey,
  ];

  Future<bool> saveToCsv(String filename, List<double> datarow) async {

    // List<EEGData> intermediate_list = [];
    // intermediate_list.add(datarow);

    List<List<dynamic>> wrapper = [datarow];
    String csv = const ListToCsvConverter().convert(wrapper);

    /// Write to a file
    String directory_path = (await getExternalStorageDirectory()).absolute.path;
    String pathOfTheFileToWrite = directory_path + filename;
    File file = new File(pathOfTheFileToWrite);
    file.writeAsString(csv);

    // bool checkResult = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
    // if (!checkResult) {

    //   var status = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    //   if (status == PermissionStatus.authorized) {

    //     List<EEGData> intermediate_list = [];
    //     intermediate_list.add(datarow);

    //     List<List<dynamic>> wrapper = [intermediate_list];
    //     String csv = const ListToCsvConverter().convert(wrapper);

    //     /// Write to a file
    //     String directory_path = (await getExternalStorageDirectory()).absolute.path + "/StreamData/";
    //     String pathOfTheFileToWrite = directory_path + filename;
    //     File file = await File(pathOfTheFileToWrite);
    //     file.writeAsString(csv);
    //   }
    // } else {

    //   List<EEGData> intermediate_list = [];
    //   intermediate_list.add(datarow);

    //   List<List<dynamic>> wrapper = [intermediate_list];
    //   String csv = const ListToCsvConverter().convert(wrapper);

    //   /// Write to a file
    //   String directory_path = (await getExternalStorageDirectory()).absolute.path + "/StreamData/";
    //   String pathOfTheFileToWrite = directory_path + filename;
    //   File file = await File(pathOfTheFileToWrite);
    //   file.writeAsString(csv);
    // }

    return true;
  }

  

  @override
  void initState() {
    super.initState();

    print('-------------------------');
    saveToCsv('data-1.csv', [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0]);
    print('-------------------------');

    streamController.stream.listen((data) {
      counter++;
      if (counter >= 9) {
        setState(() {
          _list.add(data);
          if (_list.length > 100) {
            _list.removeAt(0);
          }
          // saveToCsv('data-1.csv', data);
        });
        counter = 0;
      }
    });
  }

  @override
  void dispose() {
    streamOn = false;
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'SmartEEG',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Container(
            height: 50,
            child: MyChart(_list,
                channel: 0, channelName: '1', color: colors[0], dyn: false),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 1, channelName: '2', color: colors[1]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 2, channelName: '3', color: colors[2]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 3, channelName: '4', color: colors[3]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 4, channelName: '5', color: colors[4]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 5, channelName: '6', color: colors[5]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 6, channelName: '7', color: colors[6]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 0, channelName: '1', color: colors[7]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 1, channelName: '2', color: colors[8]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 2, channelName: '3', color: colors[9]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 3, channelName: '4', color: colors[10]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 4, channelName: '5', color: colors[12]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 5, channelName: '6', color: colors[13]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 6, channelName: '7', color: colors[14]),
          ),
          Container(
            height: 50,
            child:
                MyChart(_list, channel: 6, channelName: '7', color: colors[15]),
          ),
          Container(
            height: 75,
            child: MyChart(_list,
                channel: 7, xAxis: true, channelName: '8', color: colors[11]),
          ),
        ],
      ),
    );
  }
}
