import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

mixin Headers<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  List<GridColumn> zReportTableHeader(EdgeInsets headerPadding) {
    return <GridColumn>[
      GridColumn(
        columnName: 'Name',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Transaction ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Type',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Receipt Type', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Amount',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Total Amount', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'CashReceived',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Cash Received', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }

  List<GridColumn> pluReportTableHeader(EdgeInsets headerPadding) {
    return <GridColumn>[
      GridColumn(
        columnName: 'ItemCode',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Item Code', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Name',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Name', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Price',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Price', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'TaxRate',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Tax Rate', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Qty',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Qty', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'TotalSales',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('profit made on the sale',
              overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'CurrentStock',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Current stock', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'TaxPayable',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('TaxPayable', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'GrossProfit',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Gross profit made on the sale',
              overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }
}
