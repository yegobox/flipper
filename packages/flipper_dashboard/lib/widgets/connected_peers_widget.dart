import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/ditto_presence_provider.dart';
import 'package:ditto_live/ditto_live.dart';

class ConnectedPeersWidget extends ConsumerStatefulWidget {
  const ConnectedPeersWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConnectedPeersWidget> createState() => _ConnectedPeersWidgetState();
}

class _ConnectedPeersWidgetState extends ConsumerState<ConnectedPeersWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showPeersDialog(BuildContext context, PresenceGraph presenceGraph) {
    final peers = presenceGraph.remotePeers;
    final peerList = peers.toList();
    final localPeer = presenceGraph.localPeer;

    String shortPeerKey(String key) =>
        key.length > 20 ? '${key.substring(0, 20)}...' : key;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.hub_outlined, color: Theme.of(context).primaryColor),
            const SizedBox(width: 10),
            const Text('Network Status'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Local Device',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.laptop, size: 20, color: Colors.blue),
                ),
                title: Text(localPeer.deviceName),
                subtitle: Text(
                  shortPeerKey(localPeer.peerKey),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Online',
                    style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
              Text(
                'Connected Peers (${peers.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              if (peers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.sensors_off, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No other devices found on the network',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ensure other devices have Flipper open',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: peerList.length,
                    itemBuilder: (context, index) {
                      final peer = peerList[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.devices_other, size: 20, color: Colors.green),
                        ),
                        title: Text(peer.deviceName),
                        subtitle: Text(
                          shortPeerKey(peer.peerKey),
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                        trailing: const Icon(Icons.sync, color: Colors.green, size: 16),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final presenceAsync = ref.watch(dittoPresenceProvider);

    return presenceAsync.when(
      data: (presenceGraph) {
        if (presenceGraph == null) {
          return const Tooltip(
            message: 'Sync Service not initialized',
            child: Icon(Icons.cloud_off_outlined, color: Colors.grey, size: 20),
          );
        }

        final peers = presenceGraph.remotePeers;
        final count = peers.length;
        final isConnected = count > 0;

        return InkWell(
          onTap: () => _showPeersDialog(context, presenceGraph),
          borderRadius: BorderRadius.circular(20),
          child: Tooltip(
            message: isConnected
                ? 'Connected to $count device(s). Tap to see details.'
                : 'Searching for devices on same network...',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isConnected
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isConnected
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isConnected)
                        ScaleTransition(
                          scale: Tween(begin: 1.0, end: 1.6).animate(_pulseController),
                          child: FadeTransition(
                            opacity: ReverseAnimation(_pulseController),
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      Icon(
                        isConnected ? Icons.sensors : Icons.sensors_off,
                        color: isConnected ? Colors.green : Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isConnected ? '$count' : '0',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isConnected ? Colors.green : Colors.grey.shade700,
                    ),
                  ),
                  if (isConnected) ...[
                    const SizedBox(width: 4),
                    const Text(
                      'Live',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => const Tooltip(
        message: 'Network check error',
        child: Icon(Icons.error_outline, color: Colors.red, size: 20),
      ),
    );
  }
}


