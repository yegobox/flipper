import 'package:flipper_dashboard/export/utils/plu_excel_formula_builder.dart';
import 'package:flipper_models/db_model_export.dart';

/// Detailed PLU column order — same as [pluReportTableHeader] / on-screen grid.
const List<String> kPluDetailedExportColumnNames = [
  'ItemCode',
  'Name',
  'Barcode',
  'Price',
  'TaxRate',
  'Qty',
  'TotalSales',
  'SupplyAmount',
  'CurrentStock',
  'TaxPayable',
  'NetProfit',
];

/// Display name for a PLU line (matches [DynamicDataSource._buildTransactionItemRow]).
String pluDetailedReportItemName(TransactionItem item) {
  final nameParts = item.name.split('(');
  final name = nameParts[0].trim().toUpperCase();
  final number = nameParts.length > 1 ? nameParts[1].split(')')[0] : '';
  return number.isEmpty ? name : '$name-$number';
}

/// One detailed PLU row for the grid and Excel manual export.
///
/// [taxRatePercent] should be the rate shown in the TaxRate column (item rate,
/// else tax-type config, else 18%).
Map<String, dynamic> pluDetailedReportRow(
  TransactionItem item, {
  required double taxRatePercent,
}) {
  return {
    'ItemCode': item.itemClsCd?.toString() ?? '',
    'Name': pluDetailedReportItemName(item),
    'Barcode': TransactionItemPluMetrics.barcodeForReport(item),
    'Price': item.price,
    'TaxRate': taxRatePercent,
    'Qty': item.qty,
    // Grid "profit Made" / TotalSales column.
    'TotalSales': TransactionItemPluMetrics.profitMade(item),
    'SupplyAmount': item.splyAmt?.toDouble() ?? 0.0,
    'CurrentStock': TransactionItemPluMetrics.currentStockDisplay(item),
    'TaxPayable': TransactionItemPluMetrics.taxPayable(
      item,
      ratePercent: taxRatePercent,
    ),
    'NetProfit': TransactionItemPluMetrics.netProfitColumn(
      item,
      ratePercent: taxRatePercent,
    ),
    PluExcelRowKeys.taxTyCd: item.taxTyCd,
    PluExcelRowKeys.discount: item.discount.toDouble(),
    PluExcelRowKeys.splyAmt: item.splyAmt?.toDouble() ?? 0.0,
    PluExcelRowKeys.taxAmt: item.taxAmt,
    PluExcelRowKeys.totAmt: item.totAmt,
    PluExcelRowKeys.taxblAmt: item.taxblAmt,
  };
}
