import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<String> categories = const ["Донеры", "Бургеры", "Сэндвичи", "Десерты"];

// class CategoryList extends StatelessWidget {
//   const CategoryList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance.collection("category").snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Text("jfdkj");
//           }
//           var docs = snapshot.data!.docs.toList();
//           List<String> categList = List.empty();
//           for (var i in docs) {
//             categList.add(i['title']);
//           }
//           print(categList);

//           return ListView.builder(
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(categList[index][0]),
//               );
//             },
//           );
//         });
//   }
// }
