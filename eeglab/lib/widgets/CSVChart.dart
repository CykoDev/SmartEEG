import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/EEGData.dart';

class CSVChart extends StatefulWidget {
  const CSVChart({Key key, this.list, this.channel, this.channelName})
      : super(key: key);

  @override
  _CSVChartState createState() => _CSVChartState();

  final List<EEGData> list;
  final int channel;
  final String channelName;
}

class _CSVChartState extends State<CSVChart> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.channelName),
        Expanded(
          child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
              enablePinching: true,
              zoomMode: ZoomMode.x,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(
              visibleMinimum: 0,
              isVisible: true,
              // interval: 1,
              maximumLabels: 3,
            ),
            primaryYAxis: NumericAxis(
                title: AxisTitle(
              text: "uV",
              textStyle: TextStyle(fontSize: 10),
            )),
            series: <ChartSeries>[
              LineSeries<EEGData, String>(
                dataSource: widget.list,
                xValueMapper: (EEGData data, _) => data.time,
                yValueMapper: (EEGData data, _) => data.data[widget.channel],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
