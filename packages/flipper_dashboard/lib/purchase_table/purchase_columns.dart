import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';

List<GridColumn> buildPurchaseColumns() {
  return [
    GridColumn(
      columnName: 'Name',
      label: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Name',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
    GridColumn(
      columnName: 'Supply Price',
      label: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Supply Price',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
    GridColumn(
      columnName: 'Retail Price',
      label: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Retail Price',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
    GridColumn(
      columnName: 'Actions',
      width: 120,
      label: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerRight,
        child: const Text(
          'Actions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ];
}
