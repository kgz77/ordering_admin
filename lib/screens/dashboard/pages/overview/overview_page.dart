import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:foda_admin/constant/menu.dart';
import 'package:foda_admin/constant/route_name.dart';
import 'package:foda_admin/stats/column_chart/column_chart.dart';
import 'package:foda_admin/stats/column_chart/pie_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../../../components/foda_button.dart';
import '../../../../components/textfield.dart';
import '../../../../stats/column_chart/data_table.dart';
import '../../../../stats/column_chart/spline_chart.dart';
import '../../../../themes/app_theme.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  String dropdownvalue = 'Item 1';   
  
  // List of items in our dropdown menu
  var items = [    
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appbar: AppBar(
        title: const Text("Статиска"),
      ),
      body: 
      Column(
        
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColumnChart(),
              PieCharts(),
            ],
          ),
          
          DataTableReport(),
        ],
      ),
    );
  }
}
