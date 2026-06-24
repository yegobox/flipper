import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:supabase_models/supabase_models.dart';

/// Transaction Reports: filtered transactions plus per-tx payment breakdown from records.
class TransactionReportSnapshot {
  const TransactionReportSnapshot({
    required this.transactions,
    required this.paymentSumsByTransactionId,
    /// Total logical rows matching the Capella SQL report window before client-only filters.
    /// Used for paging; may not apply when UX filters shrink the filtered snapshot.
    this.totalRowCount = 0,
  });

  final List<ITransaction> transactions;
  final Map<String, TransactionPaymentSums> paymentSumsByTransactionId;
  final int totalRowCount;
}
