import 'package:flipper_dashboard/DynamicDataSource.dart';
import 'package:flipper_models/realm/schemas.dart';

class TransactionItemDataSource extends DynamicDataSource<TransactionItem> {
  final int rowsPerPage;
  final List<TransactionItem> _allTransactionItems;

  TransactionItemDataSource(
      this._allTransactionItems, this.rowsPerPage, this.showPluReport) {
    buildPaginatedDataGridRows();
  }

  List<TransactionItem> transactionItems = []; // Only visible items
  bool showPluReport;

  @override
  void buildPaginatedDataGridRows() {
    if (_allTransactionItems.isNotEmpty) {
      // Set data to the initial set of items for the first page
      data = _allTransactionItems.sublist(
        0,
        _allTransactionItems.length > rowsPerPage
            ? rowsPerPage
            : _allTransactionItems.length,
      );
      transactionItems.addAll(data);
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startRowIndex = newPageIndex * rowsPerPage;
    final int endIndex = startRowIndex + rowsPerPage;

    if (startRowIndex < _allTransactionItems.length) {
      // Fetch more data if needed
      if (endIndex > _allTransactionItems.length) {
        transactionItems.addAll(_allTransactionItems.sublist(
            transactionItems.length, _allTransactionItems.length));
      }

      // Update data to reflect the new transactionItems
      data = transactionItems.sublist(
        startRowIndex,
        endIndex > transactionItems.length ? transactionItems.length : endIndex,
      );
      notifyListeners();
      return true;
    } else {
      return false; // Prevent page change
    }
  }
}
