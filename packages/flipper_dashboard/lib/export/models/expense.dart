import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';

/// A model representing an expense with a name and amount
class Expense {
  /// The name of the expense
  final String name;

  /// The amount of the expense
  final double amount;

  /// Creates a new Expense instance
  const Expense({
    required this.name,
    required this.amount,
  });

  /// Creates an Expense from an ITransaction
  factory Expense.fromTransaction(ITransaction transaction) {
    return Expense(
      name: transaction.transactionType ?? 'Unknown Expense',
      amount: transaction.subTotal ?? 0.0,
    );
  }

  /// Creates a list of Expense objects from a list of ITransaction objects
  static Future<List<Expense>> fromTransactions(List<ITransaction> transactions,
      {List<ITransaction>? sales}) async {
    double taxSum = 0;
    // if we have sales, then get related transaction item to get tax expenses
    if (sales != null) {
      for (var sale in sales) {
        final relatedTransactionItems = await ProxyService.strategy
            .transactionItems(transactionId: sale.id);
        for (var item in relatedTransactionItems) {
          taxSum += item.taxAmt ?? 0.0;
        }
      }
    }
    // merge taxSum with expenses
    List<Expense> expenses = transactions
        .map((transaction) => Expense.fromTransaction(transaction))
        .toList();
    expenses.add(Expense(name: 'Tax', amount: taxSum));
    return expenses;
  }
}
