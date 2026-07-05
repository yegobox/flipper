import 'dart:async';
import 'dart:io';

import 'package:flipper_services/constants.dart';
import 'package:flipper_services/event_bus.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked_services/stacked_services.dart';

/// Shows an in-app banner when a print delegation is received.
///
/// - **Mobile**: [showSimpleNotification] via outer [OverlaySupport] (works well).
/// - **Desktop**: inserts on the navigator [Overlay] via [StackedService.navigatorKey]
///   so the banner paints above dashboard chrome (outer OverlaySupport is behind).
class DelegationNotificationListener extends StatefulWidget {
  const DelegationNotificationListener({required this.child, super.key});

  final Widget child;

  @override
  State<DelegationNotificationListener> createState() =>
      _DelegationNotificationListenerState();
}

class _DelegationNotificationListenerState
    extends State<DelegationNotificationListener> {
  StreamSubscription<DelegationReceivedEvent>? _subscription;
  final Map<String, DateTime> _lastNotified = {};
  OverlayEntry? _desktopEntry;
  OverlaySupportEntry? _mobileEntry;
  Timer? _dismissTimer;

  bool get _isDesktop =>
      !kIsWeb &&
      (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  @override
  void initState() {
    super.initState();
    _subscription =
        EventBus().on<DelegationReceivedEvent>().listen(_onDelegationReceived);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _dismissBanner();
    super.dispose();
  }

  void _dismissBanner() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _desktopEntry?.remove();
    _desktopEntry = null;
    _mobileEntry?.dismiss();
    _mobileEntry = null;
  }

  void _onDelegationReceived(DelegationReceivedEvent event) {
    final now = DateTime.now();
    final last = _lastNotified[event.transactionId];
    if (last != null && now.difference(last) < const Duration(seconds: 2)) {
      return;
    }
    _lastNotified[event.transactionId] = now;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      debugPrint(
        '[delegation-banner] showing banner for ${event.transactionId} '
        '(desktop=$_isDesktop)',
      );
      _dismissBanner();
      if (_isDesktop) {
        _showDesktopBanner(event);
      } else {
        _showMobileBanner(event);
      }
    });
  }

  void _showDesktopBanner(DelegationReceivedEvent event) {
    // NavigatorState.overlay is the navigator's own Overlay (a descendant —
    // Overlay.maybeOf(context) only finds ancestors and returns null here).
    final overlay = StackedService.navigatorKey?.currentState?.overlay;
    if (overlay == null) {
      debugPrint(
        '[delegation-banner] navigator overlay unavailable, '
        'falling back to overlay_support',
      );
      _showMobileBanner(event);
      return;
    }

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _DelegationBanner(
        title: event.title,
        body: event.body,
        onTap: () {
          _dismissBanner();
          unawaited(_openDelegations());
        },
        onDismiss: _dismissBanner,
      ),
    );
    _desktopEntry = entry;
    overlay.insert(entry);
    _dismissTimer = Timer(const Duration(seconds: 8), _dismissBanner);
  }

  void _showMobileBanner(DelegationReceivedEvent event) {
    _mobileEntry = showSimpleNotification(
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _dismissBanner();
          unawaited(_openDelegations());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              event.body,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
      background: const Color(0xFF059669),
      position: NotificationPosition.top,
      duration: const Duration(seconds: 8),
      leading: const Icon(Icons.print_outlined, color: Colors.white),
    );
  }

  Future<void> _openDelegations() async {
    const page = 'delegations';
    await ProxyService.box.writeString(
      key: kPendingDashboardPageKey,
      value: page,
    );
    EventBus().fire(const OpenDashboardPageEvent(page));
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _DelegationBanner extends StatelessWidget {
  const _DelegationBanner({
    required this.title,
    required this.body,
    required this.onTap,
    required this.onDismiss,
  });

  final String title;
  final String body;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  static const _green = Color(0xFF059669);

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Positioned(
      top: topInset + 12,
      left: 16,
      right: 16,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Material(
            color: Colors.transparent,
            elevation: 32,
            shadowColor: Colors.black54,
            borderRadius: BorderRadius.circular(14),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _green,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.print_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                body,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.95),
                                  fontSize: 13,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap to open Delegations',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: onDismiss,
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
