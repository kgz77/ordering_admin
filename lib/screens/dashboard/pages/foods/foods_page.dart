import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:foda_admin/constant/route_name.dart';

import '../../../../themes/app_theme.dart';

class FoodsPage extends StatelessWidget {
  const FoodsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appbar: AppBar(
        title: const Text("Еда"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("foods").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          var docs = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.cardPadding / 8),
            child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                TextEditingController categoryTitle =
                    TextEditingController(text: docs[index]['title']);

                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Text((index + 1).toString()),
                      ),
                      title: TextField(
                        controller: categoryTitle,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: "Редактировать",
                            onPressed: () async {
                              Navigator.pushNamed(context, editFood,
                                  arguments: docs[index]['id']);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.amber,
                            ),
                          ),
                          IconButton(
                            tooltip: "Удалить",
                            onPressed: () async {
                              DocumentReference documentReference =
                                  FirebaseFirestore.instance
                                      .collection("foods")
                                      .doc(docs[index].id);
                              await FirebaseFirestore.instance
                                  .runTransaction((transaction) async {
                                DocumentSnapshot documentSnapshot =
                                    await transaction.get(documentReference);

                                await transaction
                                    .delete(documentSnapshot.reference);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Данные успесшно удалены!"),
                                  ),
                                );
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
