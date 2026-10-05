import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:flipper_localize/flipper_localize.dart';

List<GridColumn> buildPurchaseColumns() {
  const headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

  final l10n = FlipperL10n.current;
  return [
    GridColumn(
      columnName: 'rowNumber',
      width: 70,
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          l10n.purchaseColumnNo,
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
        child: Text(
          l10n.name,
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
        child: Text(
          l10n.manualPurchaseQty,
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
        child: Text(
          l10n.purchaseSupplyPrice,
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
        child: Text(
          l10n.createRetailPrice,
          style: headerStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),

    GridColumn(
      columnName: 'Status',
      width: 120,
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          l10n.reportStatus,
          style: headerStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  ];
}
