import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

mixin Headers<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  static const Color _kZReportHeaderBg = Color(0xFFEEF2F7);
  static const Color _kZReportHeaderActive = Color(0xFF2563EB);
  static const Color _kZReportHeaderText = Color(0xFF6B7280);

  Widget _zReportHeaderLabel(
    EdgeInsets padding,
    String text, {
    bool active = false,
  }) {
    return Container(
      color: _kZReportHeaderBg,
      padding: padding,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: active ? _kZReportHeaderActive : _kZReportHeaderText,
        ),
      ),
    );
  }

  List<GridColumn> zReportTableHeader(EdgeInsets headerPadding) {
    return <GridColumn>[
      GridColumn(
        columnName: 'Name',
        label: _zReportHeaderLabel(headerPadding, 'RECEIPT NO.'),
      ),
      GridColumn(
        columnName: 'Cashier',
        label: _zReportHeaderLabel(headerPadding, 'CASHIER', active: true),
      ),
      GridColumn(
        columnName: 'Type',
        label: _zReportHeaderLabel(headerPadding, 'TYPE'),
      ),
      GridColumn(
        columnName: 'Status',
        label: _zReportHeaderLabel(headerPadding, 'STATUS'),
      ),
      GridColumn(
        columnName: 'SaleTotal',
        label: _zReportHeaderLabel(headerPadding, 'SALE TOTAL'),
      ),
      GridColumn(
        columnName: 'ByHand',
        label: _zReportHeaderLabel(headerPadding, 'BY HAND'),
      ),
      GridColumn(
        columnName: 'Credit',
        label: _zReportHeaderLabel(headerPadding, 'CREDIT'),
      ),
      GridColumn(
        columnName: 'Tax',
        label: _zReportHeaderLabel(headerPadding, 'TAX'),
      ),
      GridColumn(
        columnName: 'BalanceDue',
        label: _zReportHeaderLabel(headerPadding, 'BALANCE DUE'),
      ),
      GridColumn(
        columnName: 'Actions',
        width: 110,
        allowSorting: false,
        allowFiltering: false,
        label: _zReportHeaderLabel(headerPadding, ''),
      ),
    ];
  }

  List<GridColumn> stockTableHeader(EdgeInsets headerPadding) {
    // Only It has name and
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
          child: const Text('Name', overflow: TextOverflow.ellipsis),
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
          child: const Text('Current Stock', overflow: TextOverflow.ellipsis),
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
        columnName: 'Barcode',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Barcode', overflow: TextOverflow.ellipsis),
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
          child: const Text('profit Made', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'SupplyAmount',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Supply amount', overflow: TextOverflow.ellipsis),
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
        columnName: 'NetProfit',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Net Profit', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }
}
