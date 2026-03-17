import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:ditto_live/ditto_live.dart';

final dittoPresenceProvider = StreamProvider<PresenceGraph?>((ref) {
  final ditto = DittoService.instance.dittoInstance;
  if (ditto == null) {
    return Stream.value(null);
  }

  return Stream.multi((controller) {
    final observer = ditto.presence.observe((presenceGraph) {
      if (!controller.isClosed) {
        controller.add(presenceGraph);
      }
    });

    controller.onCancel = () {
      observer.stop();
    };
  });
});
