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
      print('EXPENSE TAX CALCULATION - Processing ${sales.length} sales');
      for (var sale in sales) {
        print(
            'EXPENSE TAX CALCULATION - Sale ID: ${sale.id}, Amount: ${sale.subTotal}');
        final relatedTransactionItems = await ProxyService.strategy
            .transactionItems(transactionId: sale.id);
        print(
            'EXPENSE TAX CALCULATION - Found ${relatedTransactionItems.length} items for sale ${sale.id}');

        for (var item in relatedTransactionItems) {
          // Only include tax as expense if item is tax type B
          print(
              'EXPENSE TAX CALCULATION - Item: ${item.name}, taxTyCd: ${item.taxTyCd}, taxAmt: ${item.taxAmt}, price: ${item.price}, qty: ${item.qty}');
          if (item.taxTyCd == 'B') {
            print(
                'EXPENSE TAX CALCULATION - Adding tax amount ${item.taxAmt} for item ${item.name}');
            // Calculate expected tax for comparison
            double expectedTax = item.price * 18 / 118;
            print(
                'EXPENSE TAX CALCULATION - Expected tax (price * 18 / 118): $expectedTax vs actual: ${item.taxAmt}');
            // Calculate alternative tax calculation
            double alternativeTax = item.price * 18 / 100;
            print(
                'EXPENSE TAX CALCULATION - Alternative tax (price * 18 / 100): $alternativeTax');

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
