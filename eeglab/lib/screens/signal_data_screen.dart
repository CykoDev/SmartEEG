// import 'dart:html';
import 'dart:math';
import 'dart:io';
import 'package:eeglab/models/EEGData.dart';
import 'package:eeglab/widgets/MyChart.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'pairing_screen.dart';
import '../data/variables.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:simple_permissions/simple_permissions.dart';

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

    /// Write to a file
    // String directory_path = (await getExternalStorageDirectory()).absolute.path;
    // String pathOfTheFileToWrite = directory_path + '/' + filename;
    // File file = new File(pathOfTheFileToWrite);
    String pathOfTheFileToWrite = path + '/' + filename;
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
              height: 67,
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
                  setState(() {
                    if (_textVal != '') {
                      fileName = _textVal + '.csv';
                    }
                    Navigator.pop(context);
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
          print(data);
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
    setState(() {
      streamOn = false;
      streamPause = false;
      newCSV = true;
    });
    if (csvData.length > 0) {
      saveToCsv(List.from(csvData), fileName);
      csvData = [];
    }
  }

  void startStream(BuildContext context) async {
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
