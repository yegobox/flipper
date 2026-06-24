import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';

/// A model representing an expense with a name and amount
class Expense {
  /// The name of the expense
  final String name;

  /// The amount of the expense
  final double amount;

  /// Creates a new Expense instance
  const Expense({required this.name, required this.amount});

  /// Creates an Expense from an ITransaction
  factory Expense.fromTransaction(ITransaction transaction) {
    return Expense(
      name: transaction.transactionType ?? 'Unknown Expense',
      amount: transaction.subTotal ?? 0.0,
    );
  }

  /// Creates a list of Expense objects from a list of ITransaction objects
  static Future<List<Expense>> fromTransactions(
    List<ITransaction> transactions, {
    List<ITransaction>? sales,
  }) async {
    double taxSum = 0;
    // if we have sales, then get related transaction item to get tax expenses
    if (sales != null && sales.isNotEmpty) {
      print('EXPENSE TAX CALCULATION - Processing ${sales.length} sales in ONE bulk query');

      // Fetch ALL transaction items for all sales in a single bulk query
      // This avoids N individual DB calls which was causing the UI hang
      final saleIds = sales.map((s) => s.id!).toList();
      
      // `transactionItemsForIds` is declared on TransactionItemInterface,
      // which DatabaseSyncInterface implements — no cast needed.
      final strategy = ProxyService.getStrategy(Strategy.capella);
      Map<String, List<TransactionItem>> groupedItems = {};
      
      try {
        groupedItems = await strategy.transactionItemsForIds(saleIds);
      } catch (e) {
        print('EXPENSE TAX CALCULATION - Bulk fetch failed, skipping tax calc: $e');
      }

      // Process the grouped items in memory (no more DB calls)
      for (final sale in sales) {
        final relatedTransactionItems = groupedItems[sale.id] ?? [];
        for (var item in relatedTransactionItems) {
          if (item.taxTyCd == 'B') {
            taxSum += item.taxAmt ?? 0.0;
          }
        }
      }
    }
    // merge taxSum with expenses
    List<Expense> expenses = transactions
        .map((transaction) => Expense.fromTransaction(transaction))
        .toList();

    talker.info('Tax sum: $taxSum');
    // Only add tax expense if there are any tax type B items
    if (taxSum > 0) {
      expenses.add(Expense(name: 'Tax', amount: taxSum));
    }
    talker.info('Expenses: ${expenses.length}');
    return expenses;
  }
}
