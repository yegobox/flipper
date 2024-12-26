import 'package:flipper_dashboard/DynamicDataSource.dart';
import 'package:flipper_models/realm_model_export.dart';

class TransactionDataSource extends DynamicDataSource<ITransaction> {
  TransactionDataSource(
      List<ITransaction> transactions, this.rowsPerPage, this.showPluReport) {
    data = transactions;
    buildPaginatedDataGridRows();
  }

  final int rowsPerPage;
  bool showPluReport;
  @override
  void buildPaginatedDataGridRows() {
    data = data.sublist(
      0,
      data.length > rowsPerPage ? rowsPerPage : data.length,
    );
  }

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
      return false; // Prevent page change
    }
  }
}

class StockDataSource extends DynamicDataSource<Variant> {
  StockDataSource(
      {required List<Variant> variants, required this.rowsPerPage}) {
    data = variants;
    buildPaginatedDataGridRows();
  }

  final int rowsPerPage;
  @override
  void buildPaginatedDataGridRows() {
    data = data.sublist(
      0,
      data.length > rowsPerPage ? rowsPerPage : data.length,
    );
  }

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
      return false; // Prevent page change
    }
  }
}
