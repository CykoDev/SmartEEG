import 'package:eeglab/models/EEGData.dart';
import 'package:eeglab/screens/channel_data_screen.dart';
import 'package:flutter/cupertino.dart';
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          LineSeries<EEGData, String>(
              enableTooltip: true,
              dataSource: _list,
              xValueMapper: (EEGData data, _) => data.time,
              yValueMapper: (EEGData data, _) => data.data[widget.channel])
        ],
      ),
      onTap: () => Navigator.of(context)
          .pushNamed(ChannelDataScreen.routeName, arguments: widget.channel),
    );
  }
}
