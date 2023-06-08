import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:foda_admin/services/authentication_service.dart';
import 'package:foda_admin/utils/common.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:toggle_list/toggle_list.dart';

import '../../../../themes/app_theme.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

enum MenuItem { item1, item2, item3, item4, item5 }

class _OrdersPageState extends State<OrdersPage> {
  final firestore = FirebaseFirestore.instance;
  bool today = true;
  bool yesterday = false;
  bool week = false;
  bool month = false;
  bool all = false;
  double todaySum = 0;
  double yesterdaySum = 0;
  double weekSum = 0;
  double monthSum = 0;
  double allSum = 0;
  // String _dropDownValue = 'One';

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appbar: AppBar(
        title: today
            ? Text("Сегодняшние заказы")
            : yesterday == true
                ? Text("Вчерашние заказы")
                : week == true
                    ? Text("Заказы за неделю")
                    : month == true
                        ? Text("Заказы за месяц")
                        : all == true
                            ? Text("Все заказы")
                            : const Text("Заказы"),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.add_shopping_cart),
          color: Colors.amber,
        ),
        actions: [
          PopupMenuButton(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
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
                  children: [Text("Сегодня"), Divider(color: Colors.white)],
                ),
              ),
              const PopupMenuItem(
                value: MenuItem.item2,
                child: Column(
                  children: [Text("Вчера"), Divider(color: Colors.white)],
                ),
              ),
              const PopupMenuItem(
                value: MenuItem.item3,
                child: Column(
                  children: [Text("Неделя"), Divider(color: Colors.white)],
                ),
              ),
              const PopupMenuItem(
                value: MenuItem.item4,
                child: Column(
                  children: [Text("Месяц"), Divider(color: Colors.white)],
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
          // Expanded(
          //   child: DropdownButton(
          //     hint: _dropDownValue == null
          //         ? Text('Dropdown')
          //         : Text(
          //             _dropDownValue,
          //             style: TextStyle(color: Colors.blue),
          //           ),
          //     isExpanded: true,
          //     iconSize: 30.0,
          //     style: TextStyle(color: Colors.blue),
          //     items: ['One', 'Two', 'Three'].map(
          //       (val) {
          //         return DropdownMenuItem<String>(
          //           value: val,
          //           child: Text(val),
          //         );
          //       },
          //     ).toList(),
          //     onChanged: (val) {
          //       setState(
          //         () {
          //           _dropDownValue = val!;
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("orders").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var temp = snapshot.data!.docs;

          // var docs =
          //     temp.where((element) => element['totalPrice'] > 500).toList();
          temp.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
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
                                  .difference(
                                      timestampToDateTime(element['createdAt']))
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
          if (today == true) {
            todaySum = 0;
            docs.forEach((element) => todaySum += element['totalPrice']);
          } else if (yesterday == true) {
            yesterdaySum = 0;
            docs.forEach((element) => yesterdaySum += element['totalPrice']);
          } else if (week == true) {
            weekSum = 0;
            docs.forEach((element) => weekSum += element['totalPrice']);
          }
          return ToggleList(
            divider: const SizedBox(height: 10),
            toggleAnimationDuration: const Duration(milliseconds: 400),
            scrollPosition: AutoScrollPosition.begin,
            trailing: const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.expand_more),
                ],
              ),
            ),
            children: List.generate(
              docs.length,
              (index) => ToggleListItem(
                leading: const Padding(
                  padding: EdgeInsets.all(7),
                  child: Icon(Icons.photo_camera_outlined),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(7),
                  child: ListTile(
                    title: Text(
                      'Заказ номер №${docs.length - index}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 17),
                    ),
                    subtitle: Text(
                      "Дата: ${readTimestamp(docs[index]['createdAt'])}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Text(
                      "Итого: ${docs[index]['totalPrice']} С̲",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                divider: const Divider(
                  color: Color.fromARGB(255, 190, 188, 188),
                  height: 2,
                  thickness: 2,
                ),
                content: Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    color: AppTheme.darkBlueLight,
                  ),
                  child: ListBody(
                    children: List.generate(
                      docs[index]['orderItems'].length,
                      (counter) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              child: Text("${counter + 1}"),
                            ),
                            title: Text(
                              "${docs[index]['orderItems'][counter]['title']}",
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              "Количество: ${docs[index]['orderItems'][counter]['quantity']}",
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              "${docs[index]['orderItems'][counter]['price']} С̲",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 190, 188, 188),
                            height: 2,
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                headerDecoration: const BoxDecoration(
                  color: AppTheme.darkBlueLight,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                expandedHeaderDecoration: const BoxDecoration(
                  color: AppTheme.darkBlueLight,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

String readTimestamp(int timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('dd/MM/yyyy HH:mm');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'DAY AGO';
    } else {
      time = diff.inDays.toString() + 'DAYS AGO';
    }
  }

  return time;
}

String readTimestampDate(int timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('dd/MM/yyyy');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'DAY AGO';
    } else {
      time = diff.inDays.toString() + 'DAYS AGO';
    }
  }

  return time;
}
