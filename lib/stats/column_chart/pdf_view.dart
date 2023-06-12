import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:foda_admin/stats/column_chart/data_table.dart';
import 'package:printing/printing.dart';
import 'package:foda_admin/stats/column_chart/data_table.dart';

class PdfView extends StatelessWidget {
  const PdfView({super.key, required this.data});
  final List<Data> data;
  @override
  Widget build(BuildContext context) {
    return AppScaffold(body: PdfPreview(build: (format) => makePdf(data)));
  }
}
