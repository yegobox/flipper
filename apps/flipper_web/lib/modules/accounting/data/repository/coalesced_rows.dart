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
///
/// A paused listener stops everything: the change feed is cancelled and no
/// read runs until it resumes, which subscribes again and reads once. Books'
/// stream providers are not auto-dispose, so when the cashier leaves Books
/// for the POS Riverpod only pauses them. Without this the feed kept reading
/// the branch's sales on the UI isolate after every sale, off-screen, and the
/// paused stream buffered each result for the rest of the session.
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
  var paused = false;
  late final StreamController<List<Map<String, dynamic>>> out;

  bool idle() => closed || paused;

  Future<void> load() async {
    if (idle()) return;
    loading = true;
    dirty = false;
    try {
      final rows = await PerfTrack.track(perfLabel, read);
      // Rows read for a listener that paused meanwhile are dropped, not
      // buffered: resuming reads again.
      if (!idle()) out.add(rows);
    } catch (e, st) {
      debugPrint('[$perfLabel] read failed: $e');
      if (!idle()) out.addError(e, st);
    } finally {
      loading = false;
      if (dirty && !idle()) {
        timer ??= Timer(coalesce, () {
          timer = null;
          unawaited(load());
        });
      }
    }
  }

  void schedule() {
    if (idle()) return;
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
        if (idle() || feedRetry != null) return;
        final dead = feed;
        feed = null;
        unawaited(dead?.cancel());
        final delay = retryDelay;
        final doubled = retryDelay * 2;
        retryDelay = doubled > retryMax ? retryMax : doubled;
        feedRetry = Timer(delay, () {
          feedRetry = null;
          if (idle()) return;
          subscribe();
          schedule();
        });
      },
    );
  }

  /// Cancels the feed and every pending read or retry.
  Future<void> stop() async {
    feedRetry?.cancel();
    feedRetry = null;
    timer?.cancel();
    timer = null;
    dirty = false;
    final current = feed;
    feed = null;
    await current?.cancel();
  }

  out = StreamController<List<Map<String, dynamic>>>(
    onListen: () {
      subscribe();
      unawaited(load());
    },
    onPause: () {
      paused = true;
      unawaited(stop());
    },
    onResume: () {
      if (closed || !paused) return;
      paused = false;
      retryDelay = retryBase;
      subscribe();
      // A read still in flight from before the pause is followed by a fresh
      // one, since what changed while paused was not watched.
      if (loading) {
        dirty = true;
      } else {
        unawaited(load());
      }
    },
    onCancel: () async {
      closed = true;
      await stop();
    },
  );
  return out.stream;
}
