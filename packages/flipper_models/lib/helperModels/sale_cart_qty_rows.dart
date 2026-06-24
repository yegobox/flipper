import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/sale_completion_helpers.dart';

/// Maps [TransactionItem] rows to [SaleCartQtyRow] for cart sync checks.
Iterable<SaleCartQtyRow> saleCartQtyRowsFromTransactionItems(
  Iterable<TransactionItem> items,
) {
  return items.map(
    (i) => (variantId: i.variantId, qty: i.qty, active: i.active),
  );
}
