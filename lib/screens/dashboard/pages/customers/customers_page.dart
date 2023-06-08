import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:foda_admin/constant/image_path.dart';
import 'package:foda_admin/constant/route_name.dart';

import '../../../../themes/app_theme.dart';
import '../orders/orders_page.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appbar: AppBar(
        title: const Text("Клиенты"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          late List docs = [];
          for (var i in snapshot.data!.docs) {
            if (i['name'] != 'admin') {
              docs.add(i);
              print("${i['profileImageUrl']}");
            }
          }
          final currentClient = docs
              .where(
                (element) =>
                    element['name'].toString().contains(controller.text),
              )
              .toList();
          return Column(
            children: [
              TextField(
                style: TextStyle(fontSize: 20),
                controller: controller,
                onChanged: (value) => setState(() {}),
                decoration: const InputDecoration(
                    hintText: "Поиск по имени",
                    hintStyle: TextStyle(fontSize: 15),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 37,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    fillColor: AppTheme.purpleDark,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        borderSide:
                            BorderSide(color: AppTheme.white, width: 1.0))),
              ),
              Expanded(
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount: currentClient.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          isThreeLine: true,
                          leading: const CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                "https://do-doma.kz/uploads/posts/2020-07/thumbs/1594655486_66666.jpg"),
                          ),
                          title: Text(
                            "${currentClient[index]['name']}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Телефон : " + currentClient[index]['phone'],
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "Адрес : " + currentClient[index]['address'],
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "Почта : " + currentClient[index]['email'],
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "Дата регистрации : " +
                                    readTimestamp(currentClient[index]['createdAt']),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Image.asset(
                              ImagePath.clientOrders,
                            ),
                            tooltip: "Заказы",
                            onPressed: () {
                              Navigator.pushNamed(context, clientOrders,
                                  arguments: currentClient[index]['uid']);
                            },
                          ),
                        ),
                        Divider(
                          color: Color.fromARGB(255, 77, 77, 77),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
