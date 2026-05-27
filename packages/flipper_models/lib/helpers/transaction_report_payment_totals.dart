import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:supabase_models/supabase_models.dart';

/// Payment breakdown for Transaction Reports KPIs / exports (Cash vs CREDIT).
double transactionReportByHandForTotals(
  ITransaction tx,
  TransactionPaymentSums? sums,
) {
  if (sums == null || !sums.hasAnyRecord) {
    return tx.cashReceived ?? 0.0;
  }
  return sums.byHand;
}

double transactionReportCreditForTotals(
  ITransaction tx,
  TransactionPaymentSums? sums,
) {
  if (sums == null || !sums.hasAnyRecord) return 0.0;
  return sums.credit;
}
