import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';

List<GridColumn> buildPurchaseColumns() {
  const headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  return [
    GridColumn(
      columnName: 'rowNumber',
      width: 70,
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'No.',
          style: headerStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
    GridColumn(
      columnName: 'Name',
      width: double.nan, // Take remaining space
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Name',
          style: headerStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
    GridColumn(
      columnName: 'Qty',
      width: 120,
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerRight,
        child: const Text(
          'Qty',
          style: headerStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
    GridColumn(
      columnName: 'Supply Price',
      width: 150,
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerRight,
        child: const Text(
          'Supply Price',
          style: headerStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
    GridColumn(
      columnName: 'Retail Price',
      width: 150,
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerRight,
        child: const Text(
          'Retail Price',
          style: headerStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
    GridColumn(
      columnName: 'Actions',
      width: 120,
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.center,
        child: const Text(
          'Actions',
          style: headerStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  ];
}
