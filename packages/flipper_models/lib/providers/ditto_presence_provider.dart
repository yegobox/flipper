import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:ditto_live/ditto_live.dart';

final dittoPresenceProvider = StreamProvider<List<Peer>>((ref) {
  final ditto = DittoService.instance.dittoInstance;
  if (ditto == null) {
    return Stream.value([]);
  }

  return Stream.multi((controller) {
    // We keep polling presence because presence.observe is not a standard stream in all ditto versions,
    // or we can use the observe method if available.
    final observer = ditto.presence.observe((presenceGraph) {
      if (!controller.isClosed) {
        final peers = presenceGraph.remotePeers;
        controller.add(peers);
      }
    });

    controller.onCancel = () {
      observer.stop();
    };
  });
});
