import 'package:eeglab/models/EEGData.dart';
import 'package:eeglab/screens/channel_data_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyChart extends StatefulWidget {
  const MyChart(this.list, this.channel, this.xAxis, this.channelName, this.color, {Key key})
      : super(key: key);

  final List<EEGData> list;
  final int channel;
  final bool xAxis;
  final String channelName;
  final Color color;

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
      child: Row(
        children: [
          Text(widget.channelName),
          Expanded(
            child: SfCartesianChart(
              palette: <Color>[widget.color],
              tooltipBehavior: TooltipBehavior(enable: true),
              primaryXAxis: CategoryAxis(
                isVisible: widget.xAxis,
                // interval: 5,
              ),
              primaryYAxis: NumericAxis(
                maximum: 1.7,
                minimum: -1.7,
                interval: 1,
                // title: AxisTitle(
                //   text: 'Channel Y',
                // ),
              ),
              series: <ChartSeries>[
                LineSeries<EEGData, String>(
                    enableTooltip: true,
                    dataSource: _list,
                    xValueMapper: (EEGData data, _) => data.time,
                    yValueMapper: (EEGData data, _) =>
                        data.data[widget.channel])
              ],
            ),
          ),
        ],
      ),
      onTap: () => Navigator.of(context)
          .pushNamed(ChannelDataScreen.routeName, arguments: widget.channel),
    );
  }
}
