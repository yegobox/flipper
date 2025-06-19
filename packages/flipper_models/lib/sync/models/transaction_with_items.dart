import 'package:flipper_models/db_model_export.dart';

/// Holds a transaction and its associated items for efficient reporting.
class TransactionWithItems {
  final ITransaction transaction;
  final List<TransactionItem> items;

  TransactionWithItems({required this.transaction, required this.items});
}
