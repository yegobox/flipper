import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';

/// Mirrors dashboard export helpers — excludes cash-book utility PLU rows.
bool transactionReportCashMovementPluLine(TransactionItem item) {
  final code = item.itemCd;
  if (code != null && code.isNotEmpty) {
    final compact = code.toUpperCase().replaceAll(' ', '');
    if (compact.startsWith('CASH-OUT') || compact.startsWith('CASH-IN')) {
      return true;
    }
  }
  final trimmed = item.name.trim();
  if (trimmed == TransactionType.cashOut || trimmed == TransactionType.cashIn) {
    return true;
  }
  return false;
}
