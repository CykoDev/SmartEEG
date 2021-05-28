// import 'dart:html';
// import 'dart:html';
import 'dart:math';
import 'dart:io';
import 'package:wakelock/wakelock.dart';
import 'package:eeglab/models/EEGData.dart';
import 'package:eeglab/widgets/MyChart.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'pairing_screen.dart';
import '../data/variables.dart';
import 'package:file_picker/file_picker.dart';

// import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
// import 'package:permission_handler/permission_handler.dart';

const MethodChannel sensorPlatform =
    MethodChannel("samples.flutter.dev/sensor");
const EventChannel _sensorStream = EventChannel("sensorDataStream");

typedef void Listener(dynamic data);
typedef void CancelListening();

class SignalDataScreen extends StatefulWidget {
  const SignalDataScreen({Key key}) : super(key: key);
  static String routeName = '/signal';

  @override
  _SignalDataScreenState createState() => _SignalDataScreenState();
}

class _SignalDataScreenState extends State<SignalDataScreen> {
  final rand = Random();

  CancelListening cancel;

  bool streamOn = false;
  bool streamPause = false;
  bool newCSV = true;
  bool listenStream = false;
  String _textVal = '';
  String fileName = '';
  double height = 75;
  double lastHeight = 90;

  final List<EEGData> _list = [];
  List<List<double>> csvData = [];

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
  ];

  CancelListening startListening(Listener listener) {
    var subscription = _sensorStream
        .receiveBroadcastStream()
        .listen(listener, cancelOnError: true);
    return () {
      subscription.cancel();
    };
  }

  Future<void> saveToCsv(List<List<double>> datarow, String filename) async {
    // List<List<double>> wrapper = [datarow];
    String csv = const ListToCsvConverter().convert(datarow);
    // print("||||||||||||||||||||||Entered saveCSV method!||||||||||||||||||||||||||||||||||");
    // File file;

    /// Write to a file
    // String directory_path = (await getExternalStorageDirectory()).absolute.path;
    // print(directory_path);
    // final dir = Directory(directory_path + '/csvFiles');
    // await dir.create().then((value) {
    //   file = File('${value.path}/${filename}');
    // });
    // String pathOfTheFileToWrite = directory_path + '/' + filename;
    // print(pathOfTheFileToWrite);
    // File file = new File(pathOfTheFileToWrite);
    // String pathOfTheFileToWrite = '/storage/emulated/0/Android/data/com.example.eeglab/files/' + filename;
    // String pathOfTheFileToWrite = '/storage/emulated/0/Csvdata/' + filename;
    String pathOfTheFileToWrite = path + '/' + filename;
    print(pathOfTheFileToWrite);
    File file = new File(pathOfTheFileToWrite);
    if (newCSV) {
      file.writeAsString(csv + '\n');
      newCSV = false;
    } else {
      file.writeAsString(csv + '\n', mode: FileMode.append);
      // streamOn = true;
    }

    // return true;
  }

  Future<void> _showFileNameDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Filename'),
            content: SizedBox(
              height: 69,
              child: Column(
                children: [
                  Text('Enter name of CSV file to save to:'),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _textVal = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() async {
                    if (_textVal == '') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Enter a file name'),
                      ));
                    } else {
                      print("TextVal had this value: " + _textVal);
                      String filename = _textVal + '.csv';
                      String filepath = path + '/' + filename;
                      if (await File(filepath).exists()) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('The file aleady exists. Overwrite?'),
                          action: SnackBarAction(
                              label: "YES",
                              onPressed: () {
                                fileName = filename;
                                Navigator.pop(context);
                              }),
                        ));
                      } else {
                        fileName = filename;
                        Navigator.pop(context);
                      }
                    }
                  });
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  }

  Future<void> getSensorData() async {
    setState(() {
      listenStream = true;
    });
    String recvMsg;
    try {
      recvMsg = await sensorPlatform.invokeMethod("initSensors");
      if (recvMsg == "True") {
        // _sensorStream.receiveBroadcastStream().listen((dynamic data) {
        //   print(data);
        // });
        cancel = startListening((dynamic data) {
          // print(data);
        });
      }
    } on PlatformException catch (e) {
      print("Encountered an error: '${e.message}'");
    }
  }

  void stopListening() {
    cancel();
    setState(() {
      listenStream = false;
    });
  }

  void stopStream() {
    print("stopping stream");
    csvData = [
      [1.0, 2.0],
      [3.0, 4.0]
    ];
    if (csvData.length > 0) {
      saveToCsv(List.from(csvData), fileName);
      csvData = [];
    }
    setState(() {
      streamOn = false;
      streamPause = false;
      newCSV = true;
    });
  }

  void startStream(BuildContext context) async {
    // dynamic status = await Permission.storage.request();
    dynamic status = await SimplePermissions.requestPermission(
        Permission.WriteExternalStorage);

    print("|||||||||||||||||||Status below!|||||||||||||||||||");
    print(status);
    if (!pathChosen) {
      String result = await FilePicker.platform.getDirectoryPath();
      setState(() {
        path = result;
        pathChosen = true;
      });
    }
    await _showFileNameDialog(context);
    if (fileName != '') {
      setState(() {
        streamOn = true;
      });
      print("Stream On: " + streamOn.toString());
    }
  }

  void pauseStream() {
    setState(() {
      streamOn = false;
      streamPause = true;
    });
  }

  void resumeStream() {
    setState(() {
      // newCSV = false;
      streamOn = true;
      streamPause = false;
    });
  }

  @override
  void initState() {
    super.initState();

    Wakelock.enable();

    //read from csv

    streamController.stream.listen((data) {
      counter++;
      if (counter >= 9) {
        setState(() {
          _list.add(data);
          if (_list.length > 100) {
            _list.removeAt(0);
          }
          List<double> reqData = data.data;

          print(reqData);
          print('-------------------------');
          if (streamOn) {
            csvData.add(reqData);
            if (csvData.length == 100) {
              saveToCsv(List.from(csvData), fileName);
              csvData = [];
            }
          }
        });
        counter = 0;
      }
    });
  }

  List<Widget> getActions(BuildContext context) {
    List<Widget> actions = [];
    if (streamOn) {
      actions = [
        IconButton(
          icon: Icon(Icons.pause),
          onPressed: () => pauseStream(),
        ),
        IconButton(
          icon: Icon(Icons.stop),
          onPressed: () => stopStream(),
        ),
      ];
    } else {
      if (streamPause) {
        actions = [
          IconButton(
            icon: Icon(Icons.play_arrow_outlined),
            onPressed: () => resumeStream(),
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () => stopStream(),
          )
        ];
      } else {
        actions = [
          IconButton(
            icon: Icon(Icons.play_arrow_rounded),
            onPressed: () => startStream(context),
          ),
        ];
      }
    }
    if (!listenStream) {
      actions.add(IconButton(
        icon: Icon(Icons.settings_input_antenna_sharp),
        onPressed: () => getSensorData(),
      ));
    } else {
      actions.add(IconButton(
        icon: Icon(Icons.not_interested),
        onPressed: () => stopListening(),
      ));
    }
    return actions;
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
        actions: getActions(context),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Container(
            height: height,
            child: MyChart(_list,
                channel: 0,
                channelName: '1',
                color: colors[0],
                dyn: dyn,
                min: min,
                max: max),
          ),
          Container(
            height: height,
            child: MyChart(_list,
                channel: 1,
                channelName: '2',
                color: colors[1],
                dyn: dyn,
                min: min,
                max: max),
          ),
          Container(
            height: height,
            child: MyChart(_list,
                channel: 2,
                channelName: '3',
                color: colors[2],
                dyn: dyn,
                min: min,
                max: max),
          ),
          Container(
            height: height,
            child: MyChart(_list,
                channel: 3,
                channelName: '4',
                color: colors[3],
                dyn: dyn,
                min: min,
                max: max),
          ),
          Container(
            height: height,
            child: MyChart(_list,
                channel: 4,
                channelName: '5',
                color: colors[4],
                dyn: dyn,
                min: min,
                max: max),
          ),
          Container(
            height: height,
            child: MyChart(_list,
                channel: 5,
                channelName: '6',
                color: colors[5],
                dyn: dyn,
                min: min,
                max: max),
          ),
          Container(
            height: height,
            child: MyChart(_list,
                channel: 6,
                channelName: '7',
                color: colors[6],
                dyn: dyn,
                min: min,
                max: max),
          ),
          Container(
            height: lastHeight,
            child: MyChart(_list,
                channel: 7,
                channelName: '8',
                color: colors[7],
                xAxis: true,
                dyn: dyn,
                min: min,
                max: max),
          ),
        ],
      ),
    );
  }
}
