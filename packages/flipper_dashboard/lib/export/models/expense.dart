import 'package:flipper_models/db_model_export.dart';

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
  static List<Expense> fromTransactions(List<ITransaction> transactions) {
    return transactions.map((transaction) => Expense.fromTransaction(transaction)).toList();
  }
}
