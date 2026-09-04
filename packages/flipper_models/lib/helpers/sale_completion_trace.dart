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

  final Stopwatch _flow = Stopwatch()..start();
  final List<_TracedStage> _stages = <_TracedStage>[];
  final List<String> _notes = <String>[];

  void record(String stage, int ms) {
    // A runaway flow must not grow this without bound.
    if (_stages.length >= 64) return;
    _stages.add(_TracedStage(stage, ms, _flow.elapsedMilliseconds));
  }

  /// Records a fact that is not a duration — which branch the sale took.
  void note(String note) {
    if (_notes.length >= 8 || _notes.contains(note)) return;
    _notes.add(note);
  }

  /// Stages worth reading, in the order they finished, as `name=took@at`.
  ///
  /// `at` is milliseconds from the start of the flow to when the stage
  /// finished. Durations alone cannot show a gap: the first breakdown of a
  /// 29s sale listed 5.6s of stages and no hint that the other 24s was in
  /// code nobody had timed. With `at`, a gap between one stage ending and the
  /// next starting is visible on the line itself.
  String summary({int minMs = 100}) {
    final parts = <String>[
      for (final stage in _stages)
        if (stage.tookMs >= minMs) '${stage.name}=${stage.tookMs}@${stage.atMs}',
      ..._notes,
    ];
    return parts.join(' ');
  }
}

class _TracedStage {
  const _TracedStage(this.name, this.tookMs, this.atMs);

  final String name;
  final int tookMs;

  /// Flow-relative milliseconds at which the stage finished.
  final int atMs;
}

/// Logs one completion stage and records it on the active trace.
void logSaleCompletionStage(String stage, int ms, {String? extra}) {
  SaleCompletionTrace.current?.record(stage, ms);
  talker.debug(
    '[sale_completion_timing] ${stage}_ms=$ms${extra == null ? '' : ' $extra'}',
  );
}
