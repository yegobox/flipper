import 'package:flipper_dashboard/utils/sale_agent_commission.dart';

export 'package:flipper_dashboard/utils/sale_agent_commission.dart'
    show applyAgentCommissionForSaleCompletionInMemory;
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';

/// Loads attribution from Ditto when missing, then applies in-memory commission.
Future<void> finalizeAgentCommissionForSaleCompletion({
  required ITransaction transaction,
  required double finalSubTotal,
  List<TransactionItem>? preloadedLineItems,
}) async {
  final needsAttributionRefresh =
      transaction.attributedAgentUserId == null ||
      transaction.attributedAgentUserId!.isEmpty;

  if (needsAttributionRefresh) {
    final mightHaveAgent =
        transaction.agentCommissionType != null ||
        transaction.agentCommissionValue != null;
    if (mightHaveAgent) {
      final capella = ProxyService.getStrategy(Strategy.capella);
      final fresh = await capella.getTransaction(
        id: transaction.id,
        branchId: transaction.branchId,
      );
      mergeAgentAttributionOnto(transaction, fresh);
    }
  }

  applyAgentCommissionForSaleCompletionInMemory(
    transaction: transaction,
    finalSubTotal: finalSubTotal,
    preloadedLineItems: preloadedLineItems,
  );
}
