import 'package:flipper_localize/flipper_localize.dart';
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
    final l10n = context.flipperL10n;
    String up(String s) => s.toUpperCase();
    return <GridColumn>[
      GridColumn(
        columnName: 'Name',
        label: _zReportHeaderLabel(headerPadding, up(l10n.reportReceiptNo)),
      ),
      GridColumn(
        columnName: 'Cashier',
        label: _zReportHeaderLabel(
          headerPadding,
          up(l10n.reportCashier),
          active: true,
        ),
      ),
      GridColumn(
        columnName: 'Customer',
        label: _zReportHeaderLabel(headerPadding, up(l10n.customer)),
      ),
      GridColumn(
        columnName: 'Type',
        label: _zReportHeaderLabel(headerPadding, up(l10n.reportType)),
      ),
      GridColumn(
        columnName: 'Status',
        label: _zReportHeaderLabel(headerPadding, up(l10n.reportStatus)),
      ),
      GridColumn(
        columnName: 'SaleTotal',
        label: _zReportHeaderLabel(headerPadding, up(l10n.reportSaleTotal)),
      ),
      GridColumn(
        columnName: 'ByHand',
        label: _zReportHeaderLabel(headerPadding, up(l10n.reportByHand)),
      ),
      GridColumn(
        columnName: 'Credit',
        label: _zReportHeaderLabel(headerPadding, up(l10n.credit)),
      ),
      GridColumn(
        columnName: 'Tax',
        label: _zReportHeaderLabel(headerPadding, up(l10n.manualPurchaseTax)),
      ),
      GridColumn(
        columnName: 'BalanceDue',
        label: _zReportHeaderLabel(headerPadding, up(l10n.reportBalanceDue)),
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
          child: Text(
            context.flipperL10n.name,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.currentStock,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.retailPrice,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.reportItemCode,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.name,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.reportBarcode,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.retailPrice,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.reportTaxRate,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.manualPurchaseQty,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.reportProfitMade,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.reportSupplyAmount,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.currentStock,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.reportTaxPayable,
            overflow: TextOverflow.ellipsis,
          ),
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
          child: Text(
            context.flipperL10n.reportNetProfit,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ];
  }
}
