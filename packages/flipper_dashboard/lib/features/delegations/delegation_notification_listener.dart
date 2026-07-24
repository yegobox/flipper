import 'dart:async';
import 'dart:io';

import 'package:flipper_services/constants.dart';
import 'package:flipper_services/event_bus.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked_services/stacked_services.dart';

/// Shows an in-app banner for print delegations and stock transfers.
///
/// Banners sit at the **bottom** (aligned with snackbars) so they do not stack
/// against the top chrome or fight POS toasts.
///
/// - **Mobile**: [showSimpleNotification] via outer [OverlaySupport].
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
  StreamSubscription<DelegationReceivedEvent>? _delegationSub;
  StreamSubscription<StockTransferNotificationEvent>? _transferSub;
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
    _delegationSub =
        EventBus().on<DelegationReceivedEvent>().listen(_onDelegationReceived);
    _transferSub = EventBus()
        .on<StockTransferNotificationEvent>()
        .listen(_onStockTransferReceived);
  }

  @override
  void dispose() {
    _delegationSub?.cancel();
    _transferSub?.cancel();
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

  bool _shouldThrottle(String key) {
    final now = DateTime.now();
    final last = _lastNotified[key];
    if (last != null && now.difference(last) < const Duration(seconds: 2)) {
      return true;
    }
    _lastNotified[key] = now;
    return false;
  }

  void _onDelegationReceived(DelegationReceivedEvent event) {
    if (_shouldThrottle(event.transactionId)) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      debugPrint(
        '[delegation-banner] showing banner for ${event.transactionId} '
        '(desktop=$_isDesktop)',
      );
      _dismissBanner();
      _showBanner(
        title: event.title,
        body: event.body,
        icon: Icons.print_outlined,
        hint: 'Tap to open Delegations',
        onTap: () {
          _dismissBanner();
          unawaited(_openDelegations());
        },
      );
    });
  }

  void _onStockTransferReceived(StockTransferNotificationEvent event) {
    if (_shouldThrottle(event.requestId)) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      debugPrint(
        '[transfer-banner] showing banner for ${event.requestId} '
        '(desktop=$_isDesktop)',
      );
      _dismissBanner();
      _showBanner(
        title: event.title,
        body: event.body,
        icon: Icons.swap_horiz,
        hint: null,
        onTap: _dismissBanner,
      );
    });
  }

  void _showBanner({
    required String title,
    required String body,
    required IconData icon,
    required String? hint,
    required VoidCallback onTap,
  }) {
    if (_isDesktop) {
      _showDesktopBanner(
        title: title,
        body: body,
        icon: icon,
        hint: hint,
        onTap: onTap,
      );
    } else {
      _showMobileBanner(
        title: title,
        body: body,
        icon: icon,
        onTap: onTap,
      );
    }
  }

  void _showDesktopBanner({
    required String title,
    required String body,
    required IconData icon,
    required String? hint,
    required VoidCallback onTap,
  }) {
    final overlay = StackedService.navigatorKey?.currentState?.overlay;
    if (overlay == null) {
      debugPrint(
        '[delegation-banner] navigator overlay unavailable, '
        'falling back to overlay_support',
      );
      _showMobileBanner(
        title: title,
        body: body,
        icon: icon,
        onTap: onTap,
      );
      return;
    }

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _DelegationBanner(
        title: title,
        body: body,
        icon: icon,
        hint: hint,
        onTap: onTap,
        onDismiss: _dismissBanner,
      ),
    );
    _desktopEntry = entry;
    overlay.insert(entry);
    _dismissTimer = Timer(const Duration(seconds: 8), _dismissBanner);
  }

  void _showMobileBanner({
    required String title,
    required String body,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    _mobileEntry = showSimpleNotification(
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              body,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
      background: const Color(0xFF059669),
      position: NotificationPosition.bottom,
      duration: const Duration(seconds: 8),
      leading: Icon(icon, color: Colors.white),
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
    required this.icon,
    required this.hint,
    required this.onTap,
    required this.onDismiss,
  });

  final String title;
  final String body;
  final IconData icon;
  final String? hint;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  static const _green = Color(0xFF059669);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      bottom: bottomInset + 20,
      left: 16,
      right: 16,
      child: Align(
        alignment: Alignment.bottomCenter,
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
                          child: Icon(icon, color: Colors.white, size: 22),
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
                              if (hint != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  hint!,
                                  style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
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
