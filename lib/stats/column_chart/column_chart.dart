import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:foda_admin/themes/app_theme.dart';
import 'package:foda_admin/utils/common.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnChart extends StatefulWidget {
  const ColumnChart({super.key});

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = [];
    Map<String, int> year = {
      'Янв': 1,
      'Фев': 2,
      'Мар': 3,
      'Апр': 4,
      'Май': 5,
      'Июн': 6,
      'Июл': 7,
      'Авг': 8,
      'Сен': 9,
      'Окт': 10,
      'Ноя': 11,
      'Дек': 12,
    };
    var _list = year.entries.toList();

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("orders").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var docs = snapshot.data!.docs;
        var currentYear = DateTime.now().year;
        double all = 0;
        for (int j = 0; j < 12; j++) {
          for (int i = 0; i < docs.length; i++) {
            DateTime temp = timestampToDateTime(docs[i]['createdAt']);
            if (temp.year == currentYear) {
              if (_list[j].value == temp.month) {
                all += int.parse(docs[i]['totalPrice'].toString());
              }
            }
          }
          chartData.add(ChartData(_list[j].key, all));
          all = 0;
        }

        return Container(
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.white),
          //   borderRadius: BorderRadius.circular(20),
          // ),
          width: 650,
          height: 300,
          child: SfCartesianChart(
            title: ChartTitle(
                text: "Статистика продаж за год",
                textStyle: const TextStyle(color: Colors.amber)),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(labelFormat: '{value} С̲'),
            series: <ChartSeries<ChartData, String>>[
              // Renders column chart
              ColumnSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                borderRadius: BorderRadius.circular(15),
                color: Colors.amber,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: AppTheme.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
