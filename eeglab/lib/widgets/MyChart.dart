import 'package:eeglab/models/EEGData.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyChart extends StatefulWidget {
  const MyChart(this.list, this.channel, {Key key}) : super(key: key);

  final List<EEGData> list;
  final int channel;

  @override
  State<StatefulWidget> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  List<EEGData> _list = [];

  @override
  void initState() {
    super.initState();
    _list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        LineSeries<EEGData, String>(
            enableTooltip: true,
            dataSource: _list,
            xValueMapper: (EEGData data, _) =>
                DateFormat('kk:mm:ss').format(data.time),
            yValueMapper: (EEGData data, _) => data.data[widget.channel])
      ],
    );
  }
}
