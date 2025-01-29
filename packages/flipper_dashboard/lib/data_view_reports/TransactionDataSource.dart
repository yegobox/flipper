import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_models/realm_model_export.dart';

class TransactionDataSource extends DynamicDataSource<ITransaction> {
  TransactionDataSource(
      List<ITransaction> transactions, this.rowsPerPage, this.showPluReport) {
    data = transactions;
  }

  final int rowsPerPage;
  bool showPluReport;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startRowIndex = newPageIndex * rowsPerPage;
    final int endIndex = startRowIndex + rowsPerPage;

    if (startRowIndex < data.length) {
      data = data.sublist(
        startRowIndex,
        endIndex > data.length ? data.length : endIndex,
      );
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}

class StockDataSource extends DynamicDataSource<Variant> {
  StockDataSource(
      {required List<Variant> variants, required this.rowsPerPage}) {
    data = variants;
  }

  final int rowsPerPage;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startRowIndex = newPageIndex * rowsPerPage;
    final int endIndex = startRowIndex + rowsPerPage;

    if (startRowIndex < data.length) {
      data = data.sublist(
        startRowIndex,
        endIndex > data.length ? data.length : endIndex,
      );
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
