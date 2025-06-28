import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_models/db_model_export.dart';

class TransactionItemDataSource extends DynamicDataSource<TransactionItem> {
  TransactionItemDataSource(
      List<TransactionItem> transactionItems, int rowsPerPage, bool showPluReport)
      : super(transactionItems, rowsPerPage) {
    this.showPluReport = showPluReport;
  }
}
