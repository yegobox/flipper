import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_models/db_model_export.dart';

class TransactionDataSource extends DynamicDataSource<ITransaction> {
  TransactionDataSource(
    List<ITransaction> transactions,
    int rowsPerPage,
    bool showPluReport, {
    Map<String, TransactionPaymentSums>? paymentSumsByTransactionId,
  }) : super(
          transactions,
          rowsPerPage,
          showPluReport: showPluReport,
          paymentSumsByTransactionId: paymentSumsByTransactionId,
        );
}

class StockDataSource extends DynamicDataSource<Variant> {
  StockDataSource({required List<Variant> variants, required int rowsPerPage})
    : super(variants, rowsPerPage);
}
