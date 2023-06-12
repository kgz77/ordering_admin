import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SplinChart extends StatefulWidget {
  const SplinChart({super.key});

  @override
  State<SplinChart> createState() => _SplinChartState();
}

class _SplinChartState extends State<SplinChart> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = <ChartData>[
      ChartData(1924, 400),
      ChartData(1925, 410),
      ChartData(1926, 405),
      ChartData(1927, 410),
      ChartData(1928, 350),
      ChartData(1929, 370),
      ChartData(1930, 500),
      ChartData(1931, 390),
      ChartData(1932, 450),
      ChartData(1933, 440),
      ChartData(1934, 350),
      ChartData(1935, 370),
      ChartData(1936, 480),
      ChartData(1937, 410),
      ChartData(1938, 530),
      ChartData(1939, 520),
      ChartData(1940, 390),
      ChartData(1941, 360),
      ChartData(1942, 405),
      ChartData(1943, 400),
    ];

    final List<Color> color = <Color>[];
    color.add(Colors.orange[500]!);
    color.add(Colors.orange);
    color.add(Colors.orange[200]!);
    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final LinearGradient gradientColors =
        LinearGradient(colors: color, stops: stops);
    return Center(
      child: Container(
        child: SfCartesianChart(
          primaryYAxis: NumericAxis(labelFormat: '{value}mm'),
          series: <ChartSeries>[
            SplineAreaSeries<ChartData, int>(
              dataSource: chartData,
              splineType: SplineType.natural,
              cardinalSplineTension: 1,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              gradient: gradientColors,
            )
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}
