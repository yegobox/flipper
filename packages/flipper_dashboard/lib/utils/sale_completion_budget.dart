import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helpers/sale_completion_trace.dart';

/// Target wall time for Pay → success feedback (excludes deferred PDF/RRA stock).
const int kSaleCompletionTargetMs = 5000;

void logSaleCompletionOverBudget({
  required int elapsedMs,
  required String source,
}) {
  if (elapsedMs <= kSaleCompletionTargetMs) return;
  // The stage lines are debug; without them on this line the only way to see
  // where an overrun went was to still have the scrollback.
  final stages = SaleCompletionTrace.current?.summary() ?? '';
  talker.warning(
    '[sale_completion_timing] over_budget_ms=$elapsedMs '
    'target_ms=$kSaleCompletionTargetMs source=$source'
    '${stages.isEmpty ? '' : ' stages(chronological, some enclose others): $stages'}',
  );
}
