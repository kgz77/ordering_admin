import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../components/app_scaffold.dart';
import '../../../../components/foda_button.dart';
import '../../../../components/textfield.dart';
import '../../../../constant/route_name.dart';

class EditFoodPage extends StatefulWidget {
  const EditFoodPage({super.key});

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  @override
  Widget build(BuildContext context) {
    var foodId = '';
    if (ModalRoute.of(context)!.settings.arguments.toString().isNotEmpty) {
      foodId = ModalRoute.of(context)!.settings.arguments as String;
    }
    return AppScaffold(
      appbar: AppBar( 
        title: const Text("Редактирование данных"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.amber,
          ),
          onPressed: () {
            Navigator.pushNamed(context, customerPath);
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("foods")
            .where("id", isEqualTo: foodId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          var docs = snapshot.data!.docs;
          
          return Padding(
            padding: const EdgeInsets.all(30),
            child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                TextEditingController title =
                    TextEditingController(text: docs[index]['title']);
                TextEditingController price = TextEditingController(
                    text: docs[index]['price'].toString());
                TextEditingController description =
                    TextEditingController(text: docs[index]['description']);
                return Column(
                  children: [
                    FodaTextfield(
                      title: "Название",
                      controller: title,
                    ),
                    SizedBox(height: 20),
                    FodaTextfield(
                      controller: description,
                      title: "Описание",
                      maxLines: 5,
                    ),
                    SizedBox(height: 20),
                    FodaTextfield(
                      title: "Цена (\С̲)",
                      controller: price,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                      ],
                    ),
                    const SizedBox(height: 20),
                    FodaButton(
                      title: "Отредактировать",
                      onTap: () async {
                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection("foods")
                            .doc(docs[index].id);
                        await FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot documentSnapshot =
                              await transaction.get(documentReference);

                          await transaction.update(documentSnapshot.reference, {
                            'title': title.text,
                            'description': description.text,
                            'price': int.parse(price.text)
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              new SnackBar(
                                  content: Text("Данные успесшно обновлены!")));
                          Navigator.pushNamed(context, foodsPath);
                        });
                      },
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