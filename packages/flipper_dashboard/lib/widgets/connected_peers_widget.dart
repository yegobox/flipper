import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/ditto_presence_provider.dart';

class ConnectedPeersWidget extends ConsumerWidget {
  const ConnectedPeersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presenceAsync = ref.watch(dittoPresenceProvider);

    return presenceAsync.when(
      data: (presenceGraph) {
        if (presenceGraph == null) {
          return const Tooltip(
            message: 'Ditto not initialized',
            child: Icon(Icons.cloud_off_outlined, color: Colors.grey, size: 20),
          );
        }

        final peers = presenceGraph.remotePeers;
        final localPeer = presenceGraph.localPeer;
        final count = peers.length;
        final isConnected = count > 0;
        return Tooltip(
          message: isConnected
              ? 'Local: ${localPeer.deviceName}\n${localPeer.peerKeyString}\n\nRemote Peers ($count):\n${peers.map((p) => '${p.deviceName}\n${p.peerKeyString}').join('\n')}'
              : 'No peers connected',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isConnected
                    ? Icons.cloud_done_outlined
                    : Icons.cloud_off_outlined,
                color: isConnected ? Colors.green : Colors.grey,
                size: 20,
              ),
              if (isConnected) const SizedBox(width: 4),
              if (isConnected)
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => const Tooltip(
        message: 'Error checking peers',
        child: Icon(Icons.error_outline, color: Colors.red, size: 20),
      ),
    );
  }
}
