import 'package:flipper_models/helperModels/talker.dart';

/// Stage timings for the sale currently being completed.
///
/// Every `[sale_completion_timing] <stage>_ms=` line is a `debug`, and the
/// stages live in two packages, so an over-budget Pay meant scrolling for them
/// after the fact — and guessing when the scrollback had rolled. The trace
/// collects them while the flow runs so the `warning` that reports the overrun
/// can name the stage that caused it.
///
/// One till completes one sale at a time, so a single ambient trace is enough.
/// Stages recorded outside a flow (the deferred stock/receipt work, which runs
/// after the operator is already free) are dropped.
class SaleCompletionTrace {
  SaleCompletionTrace._();

  static SaleCompletionTrace? _current;
  static SaleCompletionTrace? get current => _current;

  /// Starts a trace, discarding any that was left open by a sale that threw.
  static SaleCompletionTrace begin() => _current = SaleCompletionTrace._();

  static void end() => _current = null;

  final List<MapEntry<String, int>> _stages = <MapEntry<String, int>>[];

  void record(String stage, int ms) {
    // A runaway flow must not grow this without bound.
    if (_stages.length >= 64) return;
    _stages.add(MapEntry(stage, ms));
  }

  /// Stages worth reading, in the order they finished.
  ///
  /// An enclosing stage finishes after the stages inside it, so these do not
  /// sum to the total — read it as "what had happened by then", not a split.
  String summary({int minMs = 100}) {
    final parts = <String>[
      for (final stage in _stages)
        if (stage.value >= minMs) '${stage.key}=${stage.value}',
    ];
    return parts.join(' ');
  }
}

/// Logs one completion stage and records it on the active trace.
void logSaleCompletionStage(String stage, int ms, {String? extra}) {
  SaleCompletionTrace.current?.record(stage, ms);
  talker.debug(
    '[sale_completion_timing] ${stage}_ms=$ms${extra == null ? '' : ' $extra'}',
  );
}
