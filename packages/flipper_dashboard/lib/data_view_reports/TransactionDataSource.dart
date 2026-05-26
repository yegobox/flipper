import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_dashboard/transaction_report_cashier_profile.dart';
import 'package:flipper_models/db_model_export.dart';

class TransactionDataSource extends DynamicDataSource<ITransaction> {
  TransactionDataSource(
    List<ITransaction> transactions,
    int rowsPerPage,
    bool showPluReport, {
    Map<String, TransactionPaymentSums>? paymentSumsByTransactionId,
    Map<String, TransactionReportCashierProfile>? cashierDirectory,
    bool serverSidePaging = false,
  }) : super(
          transactions,
          rowsPerPage,
          showPluReport: showPluReport,
          paymentSumsByTransactionId: paymentSumsByTransactionId,
          cashierDirectory: cashierDirectory,
          serverSidePaging: serverSidePaging,
        );
}

class StockDataSource extends DynamicDataSource<Variant> {
  StockDataSource({required List<Variant> variants, required int rowsPerPage})
    : super(variants, rowsPerPage);
}
