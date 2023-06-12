import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../themes/app_theme.dart';

class PieCharts extends StatefulWidget {
  const PieCharts({super.key});

  @override
  State<PieCharts> createState() => _PieChartsState();
}

enum MenuItem { item1, item2, item3, item4, item5 }

class _PieChartsState extends State<PieCharts> {
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  bool today = true;
  bool yesterday = false;
  bool week = false;
  bool month = false;
  bool all = false;

  List<_PieData> pieData = [
    // _PieData("First", 1, "text"),
    // _PieData("Second", 2, "text2"),
    // _PieData("Third", 3, "text3"),
    // _PieData("Fourth", 4, "text4"),
    // _PieData("Fifth", 5, "text5"),
    // _PieData("Sixth", 6, "text6"),
  ];
  @override
  Widget build(BuildContext context) {
    String dropdownvalue = 'Item 1';

    // List of items in our dropdown menu
    var items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("orders").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var docsOrders = snapshot.data!.docs;
        return StreamBuilder(
          stream: FirebaseFirestore.instance.collection("foods").snapshots(),
          builder: (context, snapshot1) {
            if (!snapshot1.hasData) {
              return Container();
            }
            int amountOfEveryFoodItem = 0;
            int allSum = 0;
            var docsFoods = snapshot1.data!.docs;
            for (int i = 0; i < docsFoods.length; i++) {
              for (int o = 0; o < docsOrders.length; o++) {
                for (int oI = 0;
                    oI < docsOrders[o]['orderItems'].length;
                    oI++) {
                  if (docsFoods[i]['id'] ==
                      docsOrders[o]['orderItems'][oI]['foodId']) {
                    amountOfEveryFoodItem += int.parse(
                        docsOrders[o]['orderItems'][oI]['quantity'].toString());
                  }
                }
              }
              var title = amountOfEveryFoodItem == 0
                  ? ' '
                  : "${amountOfEveryFoodItem.toString()} шт";
              pieData.add(
                _PieData(docsFoods[i]['title'], amountOfEveryFoodItem, title),
              );
              allSum += amountOfEveryFoodItem;
              amountOfEveryFoodItem = 0;
            }
            // return PopupMenuButton(
            //   shape: const RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(15.0))),
            //   color: AppTheme.darkBlue,
            //   icon: Image.asset(
            //     "assets/icons/filter.png",
            //     color: Colors.amber,
            //   ),
            //   tooltip: "Фильтр",
            //   itemBuilder: (context) => [
            //     const PopupMenuItem(
            //       value: MenuItem.item1,
            //       child: Column(
            //         children: [Text("Сегодня"), Divider(color: Colors.white)],
            //       ),
            //     ),
            //     const PopupMenuItem(
            //       value: MenuItem.item2,
            //       child: Column(
            //         children: [Text("Вчера"), Divider(color: Colors.white)],
            //       ),
            //     ),
            //     const PopupMenuItem(
            //       value: MenuItem.item3,
            //       child: Column(
            //         children: [Text("Неделя"), Divider(color: Colors.white)],
            //       ),
            //     ),
            //     const PopupMenuItem(
            //       value: MenuItem.item4,
            //       child: Column(
            //         children: [Text("Месяц"), Divider(color: Colors.white)],
            //       ),
            //     ),
            //     const PopupMenuItem(
            //       value: MenuItem.item5,
            //       child: Column(
            //         children: [Text("Все заказы"), Divider()],
            //       ),
            //     ),
            //   ],
            //   onSelected: (value) {
            //     if (value == MenuItem.item1) {
            //       setState(() {
            //         today = true;
            //         yesterday = false;
            //         week = false;
            //         month = false;
            //         all = false;
            //       });
            //     } else if (value == MenuItem.item2) {
            //       setState(() {
            //         today = false;
            //         yesterday = true;
            //         week = false;
            //         month = false;
            //         all = false;
            //       });
            //     } else if (value == MenuItem.item3) {
            //       setState(() {
            //         today = false;
            //         yesterday = false;
            //         week = true;
            //         month = false;
            //         all = false;
            //       });
            //     } else if (value == MenuItem.item4) {
            //       setState(() {
            //         today = false;
            //         yesterday = false;
            //         week = false;
            //         month = true;
            //         all = false;
            //       });
            //     } else if (value == MenuItem.item5) {
            //       setState(() {
            //         today = false;
            //         yesterday = false;
            //         week = false;
            //         month = false;
            //         all = true;
            //       });
            //     }
            //   },
            // );

            return Column(
              children: [
                // PopupMenuButton(
                //   shape: const RoundedRectangleBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(15.0))),
                //   color: AppTheme.darkBlue,
                //   icon: Image.asset(
                //     "assets/icons/filter.png",
                //     color: Colors.amber,
                //   ),
                //   tooltip: "Фильтр",
                //   itemBuilder: (context) => [
                //     const PopupMenuItem(
                //       value: MenuItem.item1,
                //       child: Column(
                //         children: [
                //           Text("Сегодня"),
                //           Divider(color: Colors.white)
                //         ],
                //       ),
                //     ),
                //     const PopupMenuItem(
                //       value: MenuItem.item2,
                //       child: Column(
                //         children: [Text("Вчера"), Divider(color: Colors.white)],
                //       ),
                //     ),
                //     const PopupMenuItem(
                //       value: MenuItem.item3,
                //       child: Column(
                //         children: [
                //           Text("Неделя"),
                //           Divider(color: Colors.white)
                //         ],
                //       ),
                //     ),
                //     const PopupMenuItem(
                //       value: MenuItem.item4,
                //       child: Column(
                //         children: [Text("Месяц"), Divider(color: Colors.white)],
                //       ),
                //     ),
                //     const PopupMenuItem(
                //       value: MenuItem.item5,
                //       child: Column(
                //         children: [Text("Все заказы"), Divider()],
                //       ),
                //     ),
                //   ],
                //   onSelected: (value) {
                //     if (value == MenuItem.item1) {
                //       setState(() {
                //         today = true;
                //         yesterday = false;
                //         week = false;
                //         month = false;
                //         all = false;
                //       });
                //     } else if (value == MenuItem.item2) {
                //       setState(() {
                //         today = false;
                //         yesterday = true;
                //         week = false;
                //         month = false;
                //         all = false;
                //       });
                //     } else if (value == MenuItem.item3) {
                //       setState(() {
                //         today = false;
                //         yesterday = false;
                //         week = true;
                //         month = false;
                //         all = false;
                //       });
                //     } else if (value == MenuItem.item4) {
                //       setState(() {
                //         today = false;
                //         yesterday = false;
                //         week = false;
                //         month = true;
                //         all = false;
                //       });
                //     } else if (value == MenuItem.item5) {
                //       setState(() {
                //         today = false;
                //         yesterday = false;
                //         week = false;
                //         month = false;
                //         all = true;
                //       });
                //     }
                //   },
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: Container(
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.white),
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    width: 500,
                    height: 280,
                    child: SfCircularChart(
                      title: ChartTitle(
                          text: 'Количество проданных позиций: $allSum',
                          textStyle: const TextStyle(color: Colors.amber)),
                      legend: Legend(
                        isVisible: true,
                        textStyle: const TextStyle(color: Colors.amber),
                      ),
                      series: <PieSeries<_PieData, String>>[
                        PieSeries<_PieData, String>(
                          // explode: true,
                          // explodeIndex: 5,
                          dataSource: pieData,
                          xValueMapper: (_PieData data, _) => data.xData,
                          yValueMapper: (_PieData data, _) => data.yData,
                          dataLabelMapper: (_PieData data, _) => data.text,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            color: Colors.amber,
                            labelPosition: ChartDataLabelPosition.outside,
                            labelIntersectAction: LabelIntersectAction.shift,
                            connectorLineSettings: ConnectorLineSettings(
                                type: ConnectorType.curve, length: '15%'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, this.text);
  final String xData;
  final num yData;
  final String text;
}
