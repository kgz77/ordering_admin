import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:foda_admin/components/foda_button.dart';
import 'package:foda_admin/components/textfield.dart';
import 'package:foda_admin/themes/app_theme.dart';
import 'package:foda_admin/utils/common.dart';
import 'package:provider/provider.dart';

import '../../../../../constant/food_categories.dart';
import '../create_food_state.dart';

class FoodDetails extends StatefulWidget {
  const FoodDetails({Key? key}) : super(key: key);

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  List<bool> checkBoxValues = List.generate(8, (index) => true);
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CreateFoodState>();
    final firestore = FirebaseFirestore.instance;

    fodaPrint(state.detailPageIsValid);

    return StreamBuilder(
      stream: firestore.collection("category").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<DropdownMenuItem<String>> categList = [];
        final docs = snapshot.data?.docs.toList();
        for (var item in docs!) {
          categList.add(
            DropdownMenuItem(
              value: item['id'],
              child: Text("${item['title']}"),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.cardPadding),
          child: Column(
            children: [
              FodaTextfield(
                title: "Название",
                controller: state.titleController,
              ),
              const SizedBox(height: AppTheme.elementSpacing),
              FodaTextfield(
                controller: state.descriptionController,
                title: "Описание",
                maxLines: 6,
              ),
              const SizedBox(height: AppTheme.elementSpacing),
              DropdownButtonFormField<String>(
                dropdownColor: AppTheme.darkBlue,
                hint: Text(
                  "Выберите категорию",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: AppTheme.white.withOpacity(.6)),
                ),
                items: categList,
                onChanged: (value) {
                  state.setCategory(value!);
                },
              ),
              // Text("Выберите ингридиенты"),
              // StreamBuilder(
              //   stream: firestore.collection("ingridients").snapshots(),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return const CircularProgressIndicator();
              //     }
              //     var docs = snapshot.data!.docs;

              //     return Expanded(
              //       child: GridView.builder(
              //         gridDelegate:
              //             const SliverGridDelegateWithMaxCrossAxisExtent(
              //           maxCrossAxisExtent: 170,
              //           mainAxisSpacing: 20,
              //           crossAxisSpacing: 80,
              //           childAspectRatio: 3.9,
              //         ),
              //         itemCount: docs.length,
              //         itemBuilder: (context, index) {
              //           return CheckboxListTile(
              //             title: Text("${docs[index]['title']}"),
              //             value: checkBoxValues[index],
              //             onChanged: (value) {
              //               setState(() {
              //                 checkBoxValues[index] = value!;
              //               });
              //             },
              //           );
              //         },
              //       ),
              //     );
              //   },
              // ),
              const Spacer(),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FodaButton(
                    title: "Следующее",
                    state: state.detailPageIsValid
                        ? ButtonState.idle
                        : ButtonState.disabled,
                    onTap: () {
                      state.moveToNexPage();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
