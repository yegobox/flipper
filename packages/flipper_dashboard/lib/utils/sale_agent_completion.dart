import 'package:flipper_dashboard/utils/sale_agent_commission.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';

/// Loads attribution from Ditto, computes tax, and resolves commission amount.
Future<void> finalizeAgentCommissionForSaleCompletion({
  required ITransaction transaction,
  required double finalSubTotal,
}) async {
  final capella = ProxyService.getStrategy(Strategy.capella);

  final fresh = await capella.getTransaction(
    id: transaction.id,
    branchId: transaction.branchId,
  );
  mergeAgentAttributionOnto(transaction, fresh);

  var tax = transaction.taxAmount?.toDouble() ?? 0;
  if (tax <= 0) {
    final items = await capella.transactionItems(transactionId: transaction.id);
    tax = items.fold<double>(
      0,
      (sum, item) => sum + (item.taxAmt?.toDouble() ?? 0),
    );
    transaction.taxAmount = tax;
  }

  finalizeAgentCommissionAmount(
    target: transaction,
    subTotal: finalSubTotal,
    taxAmount: tax,
  );
}
