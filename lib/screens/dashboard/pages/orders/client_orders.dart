import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';

import '../../../../constant/route_name.dart';
import 'orders_page.dart';

class ClientOrders extends StatelessWidget {
  const ClientOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userId = '';
    if (ModalRoute.of(context)!.settings.arguments.toString().isNotEmpty) {
      userId = ModalRoute.of(context)!.settings.arguments as String;
    }
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("orders")
          .where("uid", isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        var docs = snapshot.data!.docs;
        // print(userId);
        return AppScaffold(
          appbar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.amber,
              ),
              onPressed: () {
                Navigator.pushNamed(context, customerPath);
              },
            ),
            title: Center(child: const Text("Заказы")),
          ),
          body: ListView.builder(
            physics: ScrollPhysics(),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          docs[index]['orderItems'][0]['coverImageUrl']),
                    ),
                    title: Text(
                      "${docs[index]['orderItems'][0]['title']}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Дата: " + readTimestamp(docs[index]['createdAt']),
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      "${docs[index]['totalPrice']} С̲",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Divider(
                    color: Color.fromARGB(255, 77, 77, 77),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
