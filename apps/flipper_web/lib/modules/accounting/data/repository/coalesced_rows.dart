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
///
/// A change feed that fails (its observer could not be registered, so it
/// sends nothing more) is subscribed to again after [retryBase], doubling up
/// to [retryMax] while it keeps failing, and each new subscription is
/// followed by one read for what the outage hid.
Stream<List<Map<String, dynamic>>> coalescedRows({
  required Future<List<Map<String, dynamic>>> Function() read,
  required Stream<void> Function() changes,
  required String perfLabel,
  Duration coalesce = const Duration(milliseconds: 250),
  Duration retryBase = const Duration(seconds: 1),
  Duration retryMax = const Duration(seconds: 30),
}) {
  StreamSubscription<void>? feed;
  Timer? feedRetry;
  var retryDelay = retryBase;
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

  void subscribe() {
    feed = changes().listen(
      (_) {
        // The feed works again: the next failure starts from the base.
        retryDelay = retryBase;
        schedule();
      },
      onError: (Object e) {
        debugPrint('[$perfLabel] change feed: $e');
        if (closed || feedRetry != null) return;
        final dead = feed;
        feed = null;
        unawaited(dead?.cancel());
        final delay = retryDelay;
        final doubled = retryDelay * 2;
        retryDelay = doubled > retryMax ? retryMax : doubled;
        feedRetry = Timer(delay, () {
          feedRetry = null;
          if (closed) return;
          subscribe();
          schedule();
        });
      },
    );
  }

  out = StreamController<List<Map<String, dynamic>>>(
    onListen: () {
      subscribe();
      unawaited(load());
    },
    onCancel: () async {
      closed = true;
      feedRetry?.cancel();
      feedRetry = null;
      timer?.cancel();
      timer = null;
      await feed?.cancel();
      feed = null;
    },
  );
  return out.stream;
}
