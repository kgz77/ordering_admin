import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:foda_admin/constant/menu.dart';
import 'package:foda_admin/constant/route_name.dart';

import '../../../../components/foda_button.dart';
import '../../../../components/textfield.dart';
import '../../../../themes/app_theme.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appbar: AppBar(
        title: const Text("Статиска"),
      ),
      body: Container(),
    );
  }
}
