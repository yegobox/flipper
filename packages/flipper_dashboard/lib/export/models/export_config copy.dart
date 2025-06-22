import 'package:flipper_models/db_model_export.dart';

/// Configuration for export operations
class ExportConfig {
  DateTime? startDate;
  DateTime? endDate;
  double? grossProfit;
  double? netProfit;
  String currencySymbol;
  String currencyFormat;
  final List<ITransaction> transactions;

  ExportConfig({
    this.startDate,
    this.endDate,
    this.grossProfit,
    this.netProfit,
    this.currencySymbol = 'RF',
    required this.transactions,
  }) : currencyFormat =
            '$currencySymbol#,##0.00_);$currencySymbol#,##0.00;$currencySymbol"-"';
}
