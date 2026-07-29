import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Live mesh presence for Connected Peers / stock completeness heuristics.
///
/// Polls [Presence.graph] instead of [Presence.observe].
///
/// In ditto_live 5.x, [PresenceObserver.stop] closes the Dart [NativeCallable]
/// without clearing the native presence callback first. Riverpod autoDispose
/// (or hot restart) then races Ditto's tokio thread and aborts with:
/// `Callback invoked after it has been deleted` (`presence_legacy` c_cb).
/// Reading [Presence.graph] never registers that FFI callback.
final dittoPresenceProvider = StreamProvider<PresenceGraph?>((ref) {
  final ditto = DittoService.instance.dittoInstance;
  if (ditto == null) {
    return Stream.value(null);
  }

  return Stream.multi((controller) {
    PresenceGraph? lastEmitted;
    var hadValue = false;

    void emitCurrent() {
      if (controller.isClosed) return;
      try {
        final live = DittoService.instance.dittoInstance;
        if (live == null || !DittoService.instance.isReady()) {
          if (hadValue) {
            hadValue = false;
            lastEmitted = null;
            controller.add(null);
          }
          return;
        }
        final graph = live.presence.graph;
        if (hadValue && lastEmitted == graph) return;
        hadValue = true;
        lastEmitted = graph;
        controller.add(graph);
      } catch (_) {
        if (!controller.isClosed && hadValue) {
          hadValue = false;
          lastEmitted = null;
          controller.add(null);
        }
      }
    }

    emitCurrent();
    final timer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => emitCurrent(),
    );

    controller.onCancel = timer.cancel;
    ref.onDispose(timer.cancel);
  });
});
