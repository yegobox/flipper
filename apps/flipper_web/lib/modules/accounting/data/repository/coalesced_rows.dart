import 'dart:async';

import 'package:flipper_models/perf/perf_track.dart';
import 'package:flutter/foundation.dart';

/// Rows that are read again at most once per [coalesce] after [changes] says
/// they may have changed.
///
/// Books used to watch transactions with an observer that decoded every
/// matching row on the UI isolate for each change. A till completes sales
/// all day, and Books' aging reads every finalized sale in the branch, so the
/// whole history was decoded on each sale. That stalled Books while people
/// recorded entries. Here a change only starts a timer, and a burst of them
/// costs one read.
Stream<List<Map<String, dynamic>>> coalescedRows({
  required Future<List<Map<String, dynamic>>> Function() read,
  required Stream<void> Function() changes,
  required String perfLabel,
  Duration coalesce = const Duration(milliseconds: 250),
}) {
  StreamSubscription<void>? feed;
  Timer? timer;
  var loading = false;
  var dirty = false;
  var closed = false;
  late final StreamController<List<Map<String, dynamic>>> out;

  Future<void> load() async {
    if (closed) return;
    loading = true;
    dirty = false;
    try {
      final rows = await PerfTrack.track(perfLabel, read);
      if (!closed) out.add(rows);
    } catch (e, st) {
      debugPrint('[$perfLabel] read failed: $e');
      if (!closed) out.addError(e, st);
    } finally {
      loading = false;
      if (dirty && !closed) {
        timer ??= Timer(coalesce, () {
          timer = null;
          unawaited(load());
        });
      }
    }
  }

  void schedule() {
    if (closed) return;
    if (loading) {
      dirty = true;
      return;
    }
    // Never pushed back by later changes, so a steady stream of sales
    // cannot starve the read.
    timer ??= Timer(coalesce, () {
      timer = null;
      unawaited(load());
    });
  }

  out = StreamController<List<Map<String, dynamic>>>(
    onListen: () {
      feed = changes().listen(
        (_) => schedule(),
        onError: (Object e) => debugPrint('[$perfLabel] change feed: $e'),
      );
      unawaited(load());
    },
    onCancel: () async {
      closed = true;
      timer?.cancel();
      timer = null;
      await feed?.cancel();
      feed = null;
    },
  );
  return out.stream;
}
