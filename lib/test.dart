// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// void main() {
//   return runApp(_ChartApp());
// }

// class _ChartApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: _MyHomePage(),
//     );
//   }
// }

// class _MyHomePage extends StatefulWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<_MyHomePage> {
//   List<_SalesData> data = [
//     _SalesData('Jan', 35),
//     _SalesData('Feb', 28),
//     _SalesData('Mar', 34),
//     _SalesData('Apr', 100),
//     _SalesData('May', 40),
//     _SalesData('June', 40),
//     _SalesData('July', 40),
//     _SalesData('August', 40),
//     _SalesData('September', 40),
//     _SalesData('October', 40),
//     _SalesData('November', 40),
//     _SalesData('December', 40),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Syncfusion Flutter chart'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             //Initialize the chart widget
//             // SfCartesianChart(
//             //     primaryXAxis: CategoryAxis(),
//             //     // Chart title
//             //     title: ChartTitle(text: 'Half yearly sales analysis'),
//             //     // Enable legend
//             //     legend: Legend(isVisible: true),
//             //     // Enable tooltip
//             //     tooltipBehavior: TooltipBehavior(enable: true),
//             //     series: <ChartSeries<_SalesData, String>>[
//             //       LineSeries<_SalesData, String>(
//             //           dataSource: data,
//             //           xValueMapper: (_SalesData sales, _) => sales.year,
//             //           yValueMapper: (_SalesData sales, _) => sales.sales,
//             //           name: 'Sales',
//             //           // Enable data label
//             //           dataLabelSettings: DataLabelSettings(isVisible: true))
//             //     ]),
//             // Expanded(
//             //   child: Padding(
//             //     padding: const EdgeInsets.all(8.0),
//             //     //Initialize the spark charts widget
//             //     child: SfSparkLineChart.custom(
//             //       //Enable the trackball
//             //       trackball: SparkChartTrackball(
//             //           activationMode: SparkChartActivationMode.tap),
//             //       //Enable marker
//             //       marker: SparkChartMarker(
//             //           displayMode: SparkChartMarkerDisplayMode.all),
//             //       //Enable data label
//             //       labelDisplayMode: SparkChartLabelDisplayMode.all,
//             //       xValueMapper: (int index) => data[index].year,
//             //       yValueMapper: (int index) => data[index].sales,
//             //       dataCount: 5,
//             //     ),
//             //   ),
//             // ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Container(
//                   width: 700,
//                   height: 300,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Colors.black,
//                     ),
//                   ),
//                   child: ,
//                 ),
//                 Container(
//                   width: 700,
//                   height: 300,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Colors.black,
//                     ),
//                   ),
//                   child: Text("kfjdkfj"),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Container(),
//                 Container(),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SalesData {
//   _SalesData(this.year, this.sales);

//   final String year;
//   final double sales;
// }
