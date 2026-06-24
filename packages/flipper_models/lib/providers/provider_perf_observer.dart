import 'package:flutter_riverpod/legacy.dart' show StateProvider;

/// Dev-only toggle for [StateObserver] provider tracing (default off).
final providerPerfTracingEnabledProvider = StateProvider<bool>((ref) => false);

/// Provider name substrings logged when tracing is enabled.
const kProviderPerfTraceAllowlist = <String>[
  'posCartDisplayItems',
  'posCartQtyForVariant',
  'pendingTransactionStream',
  'optimisticCart',
  'ticketsStream',
  'ticketSelection',
  'transactionItemList',
  'transactionReportSnapshot',
  'transactionReportKpiTotals',
  'stockByVariant',
  'stocksForVisibleVariants',
  'outerVariants',
];

bool providerPerfTraceMatches(String providerName) {
  for (final needle in kProviderPerfTraceAllowlist) {
    if (providerName.contains(needle)) return true;
  }
  return false;
}
