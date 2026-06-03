import 'package:flipper_models/helperModels/talker.dart';

/// Target wall time for Pay → success feedback (excludes deferred PDF/RRA stock).
const int kSaleCompletionTargetMs = 5000;

void logSaleCompletionOverBudget({
  required int elapsedMs,
  required String source,
}) {
  if (elapsedMs <= kSaleCompletionTargetMs) return;
  talker.warning(
    '[sale_completion_timing] over_budget_ms=$elapsedMs '
    'target_ms=$kSaleCompletionTargetMs source=$source',
  );
}
