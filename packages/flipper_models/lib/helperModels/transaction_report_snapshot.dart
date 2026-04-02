import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:supabase_models/supabase_models.dart';

/// Transaction Reports: filtered transactions plus per-tx payment breakdown from records.
class TransactionReportSnapshot {
  const TransactionReportSnapshot({
    required this.transactions,
    required this.paymentSumsByTransactionId,
  });

  final List<ITransaction> transactions;
  final Map<String, TransactionPaymentSums> paymentSumsByTransactionId;
}
