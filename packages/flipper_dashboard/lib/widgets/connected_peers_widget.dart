import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/pos_handoff_icon.dart';
import 'package:flipper_dashboard/widgets/pos_top_bar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/ditto_presence_provider.dart';
import 'package:ditto_live/ditto_live.dart';

class ConnectedPeersWidget extends ConsumerStatefulWidget {
  const ConnectedPeersWidget({super.key, this.handoffTopBarStyle = false});

  /// Handoff `.pos-iconbtn` refresh + red badge (POS top bar).
  final bool handoffTopBarStyle;

  @override
  ConsumerState<ConnectedPeersWidget> createState() =>
      _ConnectedPeersWidgetState();
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
    final media = MediaQuery.sizeOf(context);
    final maxWidth = media.width < 520 ? media.width - 48 : 460.0;

    String shortPeerKey(String key) =>
        key.length > 20 ? '${key.substring(0, 20)}...' : key;

    showDialog(
      context: context,
      barrierColor: PosTokens.ink1.withValues(alpha: 0.58),
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: 560),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: PosTokens.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: PosTokens.line),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33103240),
                  offset: Offset(0, 24),
                  blurRadius: 48,
                  spreadRadius: -18,
                ),
                BoxShadow(
                  color: Color(0x14103240),
                  offset: Offset(0, 8),
                  blurRadius: 18,
                  spreadRadius: -8,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: PosTokens.blueTint,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: PosHandoffIcons.svg(
                            'stack',
                            size: 24,
                            color: PosTokens.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Network Status',
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: PosTokens.ink1,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              peers.isEmpty
                                  ? 'This device only — no peers on the mesh yet.'
                                  : 'Synced with ${peers.length} peer'
                                      '${peers.length == 1 ? '' : 's'} on the mesh.',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                height: 1.35,
                                color: PosTokens.ink2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SectionLabel(label: 'Local device'),
                  const SizedBox(height: 8),
                  _PeerCard(
                    iconName: 'monitor',
                    iconColor: PosTokens.blue,
                    iconBackgroundColor: PosTokens.blueTint,
                    title: localPeer.deviceName,
                    subtitle: shortPeerKey(localPeer.peerKey),
                    trailing: const _StatusPill(
                      label: 'Online',
                      background: Color(0xFFDCFCE7),
                      foreground: PosTokens.gainInk,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionLabel(
                    label: 'Connected peers',
                    count: peers.length,
                  ),
                  const SizedBox(height: 8),
                  if (peers.isEmpty)
                    const _EmptyPeersState()
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: peerList.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final peer = peerList[index];
                          return _PeerCard(
                            iconName: 'monitor',
                            iconColor: PosTokens.gainInk,
                            iconBackgroundColor: const Color(0xFFDCFCE7),
                            title: peer.deviceName,
                            subtitle: shortPeerKey(peer.peerKey),
                            trailing: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: PosHandoffIcons.svg(
                                  'refresh',
                                  size: 15,
                                  color: PosTokens.gain,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: PosTokens.ink1,
                        side: const BorderSide(color: PosTokens.lineStrong),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(PosTokens.radiusMd),
                        ),
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: Text(
                        'Close',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
            child: Icon(Icons.cloud_off_outlined, color: PosTokens.ink4, size: 20),
          );
        }

        final peers = presenceGraph.remotePeers;
        final count = peers.length;
        final isConnected = count > 0;

        if (widget.handoffTopBarStyle) {
          return PosTopCircleIconButton(
            iconName: 'refresh',
            iconSize: 19,
            tooltip: isConnected
                ? 'Connected to $count device(s). Tap to see details.'
                : 'Searching for devices on same network...',
            badge: '$count',
            onPressed: () => _showPeersDialog(context, presenceGraph),
          );
        }

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
                    ? const Color(0xFFDCFCE7)
                    : PosTokens.surface2,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isConnected
                      ? PosTokens.gain.withValues(alpha: 0.35)
                      : PosTokens.line,
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
                          scale: Tween(
                            begin: 1.0,
                            end: 1.6,
                          ).animate(_pulseController),
                          child: FadeTransition(
                            opacity: ReverseAnimation(_pulseController),
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: PosTokens.gain,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      PosHandoffIcons.svg(
                        'refresh',
                        size: 14,
                        color: isConnected ? PosTokens.gain : PosTokens.ink3,
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isConnected ? '$count' : '0',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isConnected ? PosTokens.gainInk : PosTokens.ink2,
                    ),
                  ),
                  if (isConnected) ...[
                    const SizedBox(width: 4),
                    Text(
                      'Live',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: PosTokens.gain,
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
        child: Icon(Icons.error_outline, color: PosTokens.loss, size: 20),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, this.count});

  final String label;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: PosTokens.ink3,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PosTokens.blueTint,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: PosTokens.blue,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PeerCard extends StatelessWidget {
  const _PeerCard({
    required this.iconName,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String iconName;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PosTokens.surface2,
        borderRadius: BorderRadius.circular(PosTokens.radiusMd),
        border: Border.all(color: PosTokens.line),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: PosHandoffIcons.svg(
                iconName,
                size: 20,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: PosTokens.ink1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: PosTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PosHandoffIcons.svg('check', size: 12, color: foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPeersState extends StatelessWidget {
  const _EmptyPeersState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      decoration: BoxDecoration(
        color: PosTokens.surface2,
        borderRadius: BorderRadius.circular(PosTokens.radiusMd),
        border: Border.all(color: PosTokens.line),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: PosTokens.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: PosTokens.line),
            ),
            child: Center(
              child: PosHandoffIcons.svg(
                'info',
                size: 22,
                color: PosTokens.ink4,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'No other devices found',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: PosTokens.ink1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Open Flipper on another device on the same network.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 12,
              height: 1.35,
              color: PosTokens.ink3,
            ),
          ),
        ],
      ),
    );
  }
}
