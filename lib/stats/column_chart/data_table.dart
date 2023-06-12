import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:foda_admin/constant/icon_path.dart';
import 'package:foda_admin/constant/image_path.dart';
import 'package:foda_admin/stats/column_chart/pdf_view.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

import '../../themes/app_theme.dart';
import '../../utils/common.dart';

class DataTableReport extends StatefulWidget {
  const DataTableReport({super.key});

  @override
  State<DataTableReport> createState() => _DataTableReportState();
}

enum MenuItem { item1, item2, item3, item4, item5 }

class _DataTableReportState extends State<DataTableReport> {
  bool today = true;
  bool yesterday = false;
  bool week = false;
  bool month = false;
  bool all = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("orders").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var docsOrders = snapshot.data!.docs;
          return StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("foods").snapshots(),
              builder: (context, snapsho1t) {
                if (!snapsho1t.hasData) {
                  return Container();
                }
                int amountOfEveryFoodItem = 0;
                int totalPrice = 0;
                var dateTemp;

                List<Data> dataList = [];
                var docsFoods = snapsho1t.data!.docs;
                var temp = docsOrders;
                var docs = today == true
                    ? temp
                        .where((element) =>
                            timestampToDateTime(element['createdAt']).day ==
                            DateTime.now().day)
                        .toList()
                    : yesterday == true
                        ? temp
                            .where((element) =>
                                timestampToDateTime(element['createdAt']).day ==
                                DateTime.now().day - 1)
                            .toList()
                        : week == true
                            ? temp
                                .where((element) =>
                                    DateTime.now()
                                        .difference(timestampToDateTime(
                                            element['createdAt']))
                                        .inDays <=
                                    7)
                                .toList()
                            : month == true
                                ? temp
                                    .where((element) =>
                                        DateTime.now()
                                            .difference(timestampToDateTime(
                                                element['createdAt']))
                                            .inDays <=
                                        30)
                                    .toList()
                                : all == true
                                    ? temp
                                    : temp;
                int tempCheckDate = today == true
                    ? 1
                    : yesterday == true
                        ? 2
                        : week == true
                            ? 7
                            : month == true
                                ? 30
                                : all == true
                                    ? 100
                                    : 1;

                for (int i = 0; i < docsFoods.length; i++) {
                  for (int o = 0; o < docs.length; o++) {
                    for (int oI = 0; oI < docs[o]['orderItems'].length; oI++) {
                      if (docsFoods[i]['id'] ==
                          docs[o]['orderItems'][oI]['foodId']) {
                        amountOfEveryFoodItem += int.parse(
                            docs[o]['orderItems'][oI]['quantity'].toString());
                        // totalPrice += int.parse(
                        //     docs[o]['orderItems'][oI]['price'].toString());
                      }
                    }
                  }
                  totalPrice = int.parse(docsFoods[i]['price'].toString()) *
                      amountOfEveryFoodItem;
                  dataList.add(Data(i + 1, docsFoods[i]['title'],
                      amountOfEveryFoodItem, totalPrice, tempCheckDate));
                  amountOfEveryFoodItem = 0;
                  totalPrice = 0;
                }
                // var temp = dataList;

                DataListSource dataListSource = DataListSource(data: dataList);
                return Stack(
                  children: [
                    SizedBox(
                      width: 1100,
                      height: 460,
                      child: SfDataGridTheme(
                        data: SfDataGridThemeData(
                          headerColor: const Color(0xff009889),
                        ),
                        child: SfDataGrid(
                          headerRowHeight: 50,
                          rowHeight: 35,
                          columnWidthMode: ColumnWidthMode.fill,
                          source: dataListSource,
                          tableSummaryRows: [
                            GridTableSummaryRow(
                                color: Colors.amber,
                                showSummaryInRow: true,
                                title: 'Итоговая сумма: {Сумма}',
                                columns: [
                                  const GridSummaryColumn(
                                      name: 'Сумма',
                                      columnName: 'totalSum',
                                      summaryType: GridSummaryType.sum)
                                ],
                                position: GridTableSummaryRowPosition.bottom)
                          ],
                          columns: [
                            GridColumn(
                                columnName: 'number',
                                label: Container(
                                    padding: EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '№',
                                    ))),
                            GridColumn(
                                columnName: 'title',
                                label: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Text('Название'))),
                            GridColumn(
                                columnName: 'amount',
                                label: Container(
                                    padding: EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Количество',
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                            GridColumn(
                                columnName: 'totalSum',
                                label: Container(
                                    padding: EdgeInsets.all(3.0),
                                    alignment: Alignment.center,
                                    child: Text('Сумма'))),
                          ],
                        ),
                      ),

                      // child: DataTable(
                      //   // border: const TableBorder(
                      //   //     horizontalInside: BorderSide(color: Colors.white)),
                      //   border: TableBorder.all(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(4)),
                      //   showBottomBorder: true,

                      //   dividerThickness: 2,
                      //   columns: const <DataColumn>[
                      //     DataColumn(
                      //       label: Expanded(
                      //         child: Text(
                      //           '№',
                      //           style: TextStyle(
                      //               fontStyle: FontStyle.italic, fontSize: 15),
                      //         ),
                      //       ),
                      //     ),
                      //     DataColumn(
                      //       label: Expanded(
                      //         child: Text(
                      //           'Название',
                      //           style: TextStyle(
                      //               fontStyle: FontStyle.italic, fontSize: 15),
                      //         ),
                      //       ),
                      //     ),
                      //     DataColumn(
                      //       label: Expanded(
                      //         child: Text(
                      //           'Количество',
                      //           style: TextStyle(
                      //               fontStyle: FontStyle.italic, fontSize: 15),
                      //         ),
                      //       ),
                      //     ),
                      //     DataColumn(
                      //       label: Expanded(
                      //         child: Text(
                      //           'Сумма',
                      //           style: TextStyle(
                      //               fontStyle: FontStyle.italic, fontSize: 15),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      //   // rows:
                      //   //     docsFoods // Loops through dataColumnText, each iteration assigning the value to element
                      //   //         .map(
                      //   //           ((element) => DataRow(
                      //   //                 cells: <DataCell>[
                      //   //                   DataCell(Text(element[
                      //   //                       "title"])), //Extracting from Map element the value
                      //   //                   DataCell(Text(element["Number"])),
                      //   //                   DataCell(Text(element["State"])),
                      //   //                 ],
                      //   //               )),
                      //   //         )
                      //   //         .toList(),

                      //   // rows: const <DataRow>[
                      //   //   DataRow(
                      //   //     cells: <DataCell>[
                      //   //       DataCell(Text('Sarah')),
                      //   //       DataCell(Text('19')),
                      //   //       DataCell(Text('Student')),
                      //   //     ],
                      //   //   ),
                      //   //   DataRow(
                      //   //     cells: <DataCell>[
                      //   //       DataCell(Text('Janine')),
                      //   //       DataCell(Text('43')),
                      //   //       DataCell(Text('Professor')),
                      //   //     ],
                      //   //   ),
                      //   //   DataRow(
                      //   //     cells: <DataCell>[
                      //   //       DataCell(Text('William')),
                      //   //       DataCell(Text('27')),
                      //   //       DataCell(Text('Associate Professor')),
                      //   //     ],
                      //   //   ),
                      //   // ],

                      //   rows: List.generate(docsFoods.length, (index) {
                      //     return DataRow(
                      //       cells: <DataCell>[
                      //         DataCell(Text(
                      //           dataList[index].number.toString(),
                      //           style: const TextStyle(fontSize: 13),
                      //         )),
                      //         DataCell(Text(
                      //           dataList[index].title,
                      //           style: const TextStyle(fontSize: 13),
                      //         )),
                      //         DataCell(Text(dataList[index].amount.toString(),
                      //             style: const TextStyle(fontSize: 13))),
                      //         DataCell(Text(
                      //             dataList[index].totalSum.toString() + "С̲",
                      //             style: const TextStyle(fontSize: 13))),
                      //       ],
                      //     );
                      //   }),
                      // ),
                    ),
                    Positioned(
                      top: 3,
                      right: 5,
                      child: IconButton(
                        tooltip: "Распечатать в PDF формате",
                        onPressed: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PdfView(
                                    data: dataList,
                                  ))),
                        },
                        icon: Icon(
                          Icons.print,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      color: AppTheme.darkBlue,
                      icon: Image.asset(
                        "assets/icons/filter.png",
                        color: Colors.amber,
                      ),
                      tooltip: "Фильтр",
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: MenuItem.item1,
                          child: Column(
                            children: [
                              Text("Сегодня"),
                              Divider(color: Colors.white)
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: MenuItem.item2,
                          child: Column(
                            children: [
                              Text("Вчера"),
                              Divider(color: Colors.white)
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: MenuItem.item3,
                          child: Column(
                            children: [
                              Text("Неделя"),
                              Divider(color: Colors.white)
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: MenuItem.item4,
                          child: Column(
                            children: [
                              Text("Месяц"),
                              Divider(color: Colors.white)
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: MenuItem.item5,
                          child: Column(
                            children: [Text("Все заказы"), Divider()],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == MenuItem.item1) {
                          setState(() {
                            today = true;
                            yesterday = false;
                            week = false;
                            month = false;
                            all = false;
                          });
                        } else if (value == MenuItem.item2) {
                          setState(() {
                            today = false;
                            yesterday = true;
                            week = false;
                            month = false;
                            all = false;
                          });
                        } else if (value == MenuItem.item3) {
                          setState(() {
                            today = false;
                            yesterday = false;
                            week = true;
                            month = false;
                            all = false;
                          });
                        } else if (value == MenuItem.item4) {
                          setState(() {
                            today = false;
                            yesterday = false;
                            week = false;
                            month = true;
                            all = false;
                          });
                        } else if (value == MenuItem.item5) {
                          setState(() {
                            today = false;
                            yesterday = false;
                            week = false;
                            month = false;
                            all = true;
                          });
                        }
                      },
                    ),
                  ],
                );
              });
        });
  }
}

class Data {
  Data(this.number, this.title, this.amount, this.totalSum, this.checkDate);
  final num number;
  final String title;
  final num amount;
  final num totalSum;
  final int checkDate;
}

class DataListSource extends DataGridSource {
  DataListSource({required List<Data> data}) {
    _dataRow = data
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell(columnName: "number", value: e.number),
            DataGridCell(columnName: "title", value: e.title),
            DataGridCell(columnName: "amount", value: e.amount),
            DataGridCell(columnName: "totalSum", value: e.totalSum)
          ]),
        )
        .toList();
  }
  List<DataGridRow> _dataRow = [];
  @override
  List<DataGridRow> get rows => _dataRow;

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      // padding: EdgeInsets.all(15.0),
      child: Text(
        summaryValue,
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.amber,
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(2)),
        alignment: Alignment.center,
        // padding: EdgeInsets.all(1.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

Future<Uint8List> makePdf(List<Data> data) async {
  final pdf = pw.Document();
  final imageLogo = MemoryImage(
      (await rootBundle.load("assets/images/pngegg.png")).buffer.asUint8List());
  final font = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
  final ttf = pw.Font.ttf(font);
  final now = DateTime.now();
  var t = data.first.checkDate;
  String date = t == 1
      ? now.toString().substring(0, 10)
      : t == 2
          ? now.subtract(Duration(days: 1)).toString().substring(0, 10) +
              " | " +
              now.toString().substring(0, 10)
          : t == 7
              ? now.subtract(Duration(days: 7)).toString().substring(0, 10) +
                  " | " +
                  now.toString().substring(0, 10)
              : t == 30
                  ? now
                          .subtract(Duration(days: 30))
                          .toString()
                          .substring(0, 10) +
                      " | " +
                      now.toString().substring(0, 10)
                  : t == 100
                      ? now.toString().substring(0, 10)
                      : '';

  num total = 0;
  for (var i in data) {
    total += i.totalSum;
  }
  pdf.addPage(
    pw.Page(
      pageTheme: pw.PageTheme(
          theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: ttf))),
      build: (context) {
        return pw.Container(
          child: pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Отчет о продажах по позициям",
                      style: pw.TextStyle(
                        fontSize: 20,
                      )),
                  pw.Container(
                    width: 60,
                    height: 60,
                    child: pw.Image(pw.MemoryImage(imageLogo.bytes)),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Table.fromTextArray(
                headers: ['№', 'Название', 'Количетво', 'Сумма'],
                data: List.generate(
                  data.length,
                  (index) {
                    return [
                      data[index].number,
                      data[index].title,
                      data[index].amount,
                      data[index].totalSum
                    ];
                  },
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Дата создания отчета:  $date"),
                  pw.Text("Итоговая сумма: $total")
                ],
              ),
              // pw.Table(
              //   children: [
              //     pw.TableRow(
              //       children: [
              //         pw.Column(children: [
              //           pw.Text('№', style: pw.TextStyle(fontSize: 20.0))
              //         ]),
              //         pw.Column(children: [
              //           pw.Text('Название', style: pw.TextStyle(fontSize: 20.0))
              //         ]),
              //         pw.Column(children: [
              //           pw.Text('Количество',
              //               style: pw.TextStyle(fontSize: 20.0))
              //         ]),
              //         pw.Column(children: [
              //           pw.Text('Сумма', style: pw.TextStyle(fontSize: 20.0))
              //         ]),
              //       ],
              //     ),
              //     pw.TableRow(
              //       children: [
              //         pw.Column(children: [
              //           pw.Text('${data[0].number}',
              //               style: pw.TextStyle(fontSize: 10.0))
              //         ]),
              //         pw.Column(children: [
              //           pw.Text('${data[0].title}',
              //               style: pw.TextStyle(fontSize: 10.0))
              //         ]),
              //         pw.Column(children: [
              //           pw.Text('${data[0].amount}',
              //               style: pw.TextStyle(fontSize: 10.0))
              //         ]),
              //         pw.Column(children: [
              //           pw.Text('${data[0].totalSum}',
              //               style: pw.TextStyle(fontSize: 10.0))
              //         ]),
              //       ],
              //     ),
              //     pw.TableRow(
              //       children: [
              //         pw.Column(children: [
              //           pw.Text('${data[1].number}',
              //               style: pw.TextStyle(fontSize: 10.0))
              //         ]),
              //         pw.Column(children: [
              //           pw.Text('${data[1].title}',
              //               style: pw.TextStyle(fontSize: 10.0))
              //         ]),
              //         pw.Column(children: [
              //           pw.Text('${data[1].amount}',
              //               style: pw.TextStyle(fontSize: 10.0))
              //         ]),
              //         pw.Column(children: [
              //           pw.Text('${data[1].totalSum}',
              //               style: pw.TextStyle(fontSize: 10.0))
              //         ]),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        );
      },
    ),
  );
  return pdf.save();
}
