import 'dart:async';

import 'package:flipper_dashboard/features/admin/mobile/settings_list.dart'
    show settingsPageAppBar;
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_section_label.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/bulk_rra_client.dart'
    show resolveDataConnectorBaseUrl;
import 'package:flipper_models/sms_bridge_client.dart';
import 'package:flipper_services/data_connector_url.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Where phones download the bridge app. `.github/workflows/sms_bridge.yml`
/// replaces this asset on every `sms-bridge-v*` release, so the link (and
/// the QR printed from it) never changes.
const String kSmsBridgeDownloadUrl =
    'https://github.com/yegobox/flipper/releases/download/sms-bridge-latest/flipper-sms-bridge.apk';

/// How often the page looks for the phone while a code is on screen.
const Duration kSmsBridgePairPoll = Duration(seconds: 4);

/// The connector client for this branch. Tests override it with a fake.
final smsBridgeClientProvider = Provider<SmsBridgeClient>(
  (ref) => SmsBridgeClient(
    baseUrl: () async => resolveDataConnectorBaseUrl(
      dataConnectorUrl: await resolveEbmDataConnectorUrl(),
    ),
  ),
);

/// Phones paired with this business.
final smsBridgeDevicesProvider =
    FutureProvider.autoDispose<List<SmsBridgeDevice>>(
      (ref) => ref.watch(smsBridgeClientProvider).listDevices(),
    );

/// Settings → SMS Bridge: install the app, pair a phone that forwards bank
/// and MoMo SMS, and manage the phones already paired.
///
/// While a code is on screen the page polls the device list, so the moment
/// the phone claims the code it flips to "<phone> is paired" by itself.
class SmsBridgePage extends ConsumerStatefulWidget {
  const SmsBridgePage({
    super.key,
    this.canOpenOnThisPhone,
    this.now = DateTime.now,
  });

  /// Whether to offer "Open SMS Bridge on this phone". Null means Android
  /// only (the bridge is an Android app); tests set it explicitly.
  final bool? canOpenOnThisPhone;

  /// The clock the code countdown reads. Tests pass one they can move.
  final DateTime Function() now;

  @override
  ConsumerState<SmsBridgePage> createState() => _SmsBridgePageState();
}

class _SmsBridgePageState extends ConsumerState<SmsBridgePage> {
  SmsBridgePairing? _pairing;
  SmsBridgeDevice? _justPaired;
  Set<String> _knownIds = const {};
  bool _busy = false;
  String? _error;
  Timer? _tick;
  Timer? _poll;

  bool get _canOpenHere =>
      widget.canOpenOnThisPhone ??
      (!kIsWeb && defaultTargetPlatform == TargetPlatform.android);

  bool get _expired =>
      _pairing != null && !_pairing!.expiresAt.isAfter(widget.now());

  @override
  void dispose() {
    _stopTimers();
    super.dispose();
  }

  void _stopTimers() {
    _tick?.cancel();
    _poll?.cancel();
    _tick = null;
    _poll = null;
  }

  Future<void> _pair() async {
    setState(() {
      _busy = true;
      _error = null;
      _justPaired = null;
    });
    final client = ref.read(smsBridgeClientProvider);
    try {
      // Phones already paired don't count as "the one we're waiting for".
      final before = await client.listDevices();
      final pairing = await client.createPairing();
      if (!mounted) return;
      setState(() {
        _knownIds = {for (final d in before) d.deviceId};
        _pairing = pairing;
      });
      _startTimers();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = context.flipperL10n.smsBridgeError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _startTimers() {
    _stopTimers();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      if (_expired) _stopTimers();
    });
    _poll = Timer.periodic(kSmsBridgePairPoll, (_) => _checkPaired());
  }

  Future<void> _checkPaired() async {
    try {
      final devices = await ref.read(smsBridgeClientProvider).listDevices();
      if (!mounted || _pairing == null) return;
      final fresh = devices.where((d) => !_knownIds.contains(d.deviceId));
      if (fresh.isEmpty) return;
      _stopTimers();
      setState(() {
        _justPaired = fresh.first;
        _pairing = null;
      });
      ref.invalidate(smsBridgeDevicesProvider);
    } catch (_) {
      // A missed poll is harmless; the next one tries again.
    }
  }

  Future<void> _openOnThisPhone() async {
    final pairing = _pairing;
    if (pairing == null) return;
    final l10n = context.flipperL10n;
    final messenger = ScaffoldMessenger.of(context);
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(pairing.qrPayload),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      opened = false;
    }
    if (!opened) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.smsBridgeNotInstalled)),
      );
    }
  }

  Future<void> _copy(String text) async {
    final l10n = context.flipperL10n;
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: text));
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.smsBridgeCopied),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _revoke(SmsBridgeDevice device) async {
    final l10n = context.flipperL10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: PosTokens.surface,
        surfaceTintColor: Colors.transparent,
        content: Text(
          l10n.smsBridgeRevokeConfirm,
          style: const TextStyle(fontSize: 15, color: PosTokens.ink1),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: PosTokens.ink2),
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: PosTokens.lossInk),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.smsBridgeRevoke),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _error = null);
    try {
      await ref.read(smsBridgeClientProvider).revoke(device.deviceId);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = l10n.smsBridgeError(e.toString()));
    }
    if (mounted) ref.invalidate(smsBridgeDevicesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final devices = ref.watch(smsBridgeDevicesProvider);
    return Scaffold(
      backgroundColor: MposTokens.bg,
      appBar: settingsPageAppBar(context, l10n.smsBridgeTitle),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              children: [
                Text(
                  l10n.smsBridgeHeadline,
                  style: const TextStyle(
                    fontSize: 22,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: PosTokens.ink1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.smsBridgeSubtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: PosTokens.ink2,
                  ),
                ),
                const SizedBox(height: 24),
                _Step(
                  number: 1,
                  title: l10n.smsBridgeStepInstall,
                  child: _InstallCard(onCopy: _copy),
                ),
                const SizedBox(height: 20),
                _Step(
                  number: 2,
                  title: l10n.smsBridgeStepPair,
                  child: _Card(child: _pairBody(l10n)),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: const TextStyle(
                      color: PosTokens.lossInk,
                      fontSize: 13,
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: MposSectionLabel(l10n.smsBridgeDevices),
                ),
                const SizedBox(height: 8),
                devices.when(
                  loading: () => const _Card(
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: PosTokens.blue,
                        ),
                      ),
                    ),
                  ),
                  error: (e, _) => _Card(
                    child: Text(
                      l10n.smsBridgeError(e.toString()),
                      style: const TextStyle(color: PosTokens.lossInk),
                    ),
                  ),
                  data: (list) => list.isEmpty
                      ? _Card(
                          child: Text(
                            l10n.smsBridgeNoDevices,
                            style: const TextStyle(color: PosTokens.ink3),
                          ),
                        )
                      : _DeviceList(devices: list, onRevoke: _revoke),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pairBody(FlipperAppLocalizations l10n) {
    final paired = _justPaired;
    if (paired != null) {
      return _PairedNotice(device: paired, onPairAnother: _busy ? null : _pair);
    }
    final pairing = _pairing;
    if (pairing == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.smsBridgePairBody,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: PosTokens.ink2,
            ),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            key: const Key('sms_bridge_pair'),
            icon: Icons.qr_code_2_rounded,
            label: l10n.smsBridgePairPhone,
            busy: _busy,
            onPressed: _busy ? null : _pair,
          ),
        ],
      );
    }
    return _PairingCode(
      pairing: pairing,
      now: widget.now(),
      expired: _expired,
      busy: _busy,
      canOpenHere: _canOpenHere,
      onNewCode: _pair,
      onCopy: () => _copy(pairing.displayCode),
      onOpenHere: _openOnThisPhone,
    );
  }
}

/// "1  Install the app" heading above its card.
class _Step extends StatelessWidget {
  const _Step({required this.number, required this.title, required this.child});

  final int number;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: PosTokens.blueTint,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: PosTokens.blue,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: PosTokens.ink1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PosTokens.surface,
        borderRadius: BorderRadius.circular(MposTokens.radiusMd),
        border: Border.all(color: PosTokens.line),
      ),
      child: child,
    );
  }
}

class _InstallCard extends StatelessWidget {
  const _InstallCard({required this.onCopy});

  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return _Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.smsBridgeInstallBody,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: PosTokens.ink2,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  key: const Key('sms_bridge_copy_link'),
                  style: TextButton.styleFrom(
                    foregroundColor: PosTokens.blue,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 36),
                  ),
                  onPressed: () => onCopy(kSmsBridgeDownloadUrl),
                  icon: const Icon(Icons.link_rounded, size: 18),
                  label: Text(
                    l10n.smsBridgeCopyLink,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: PosTokens.line),
            ),
            child: QrImageView(
              key: const Key('sms_bridge_download_qr'),
              data: kSmsBridgeDownloadUrl,
              version: QrVersions.auto,
              size: 104,
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PairingCode extends StatelessWidget {
  const _PairingCode({
    required this.pairing,
    required this.now,
    required this.expired,
    required this.busy,
    required this.canOpenHere,
    required this.onNewCode,
    required this.onCopy,
    required this.onOpenHere,
  });

  final SmsBridgePairing pairing;
  final DateTime now;
  final bool expired;
  final bool busy;
  final bool canOpenHere;
  final VoidCallback onNewCode;
  final VoidCallback onCopy;
  final VoidCallback onOpenHere;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final left = pairing.expiresAt.difference(now);
    final countdown =
        '${left.inMinutes}:${(left.inSeconds % 60).toString().padLeft(2, '0')}';
    return Column(
      children: [
        AnimatedOpacity(
          opacity: expired ? 0.15 : 1,
          duration: const Duration(milliseconds: 250),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: PosTokens.line),
            ),
            child: QrImageView(
              key: const Key('sms_bridge_qr'),
              data: pairing.qrPayload,
              version: QrVersions.auto,
              size: 200,
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.smsBridgeTypeCode,
          style: const TextStyle(fontSize: 13, color: PosTokens.ink3),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shrinks rather than overflows on a narrow phone or big font.
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  pairing.displayCode,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontFamilyFallback: const [
                      'Menlo',
                      'Consolas',
                      'Roboto Mono',
                    ],
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    color: expired ? PosTokens.ink4 : PosTokens.ink1,
                    decoration: expired ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              key: const Key('sms_bridge_copy_code'),
              tooltip: l10n.smsBridgeCopyCode,
              onPressed: expired ? null : onCopy,
              icon: const Icon(Icons.copy_rounded, size: 20),
              color: PosTokens.ink3,
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (expired)
          Text(
            l10n.smsBridgeCodeExpired,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: PosTokens.lossInk,
            ),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // A still dot, not a spinner: the page polls quietly, and an
              // endless animation would also never let widget tests settle.
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: PosTokens.blue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${l10n.smsBridgeWaiting}  ·  ${l10n.smsBridgeExpiresIn(countdown)}',
                  key: const Key('sms_bridge_countdown'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: PosTokens.ink3),
                ),
              ),
            ],
          ),
        const SizedBox(height: 18),
        if (canOpenHere && !expired) ...[
          _PrimaryButton(
            key: const Key('sms_bridge_open_here'),
            icon: Icons.open_in_new_rounded,
            label: l10n.smsBridgeOpenOnThisPhone,
            onPressed: onOpenHere,
          ),
          const SizedBox(height: 10),
        ],
        expired
            ? _PrimaryButton(
                key: const Key('sms_bridge_new_code'),
                icon: Icons.refresh_rounded,
                label: l10n.smsBridgeNewCode,
                busy: busy,
                onPressed: busy ? null : onNewCode,
              )
            : _SecondaryButton(
                key: const Key('sms_bridge_new_code'),
                label: l10n.smsBridgeNewCode,
                onPressed: busy ? null : onNewCode,
              ),
      ],
    );
  }
}

class _PairedNotice extends StatelessWidget {
  const _PairedNotice({required this.device, required this.onPairAnother});

  final SmsBridgeDevice device;
  final VoidCallback? onPairAnother;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Column(
      key: const Key('sms_bridge_paired'),
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: MposTokens.gainTint,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: MposTokens.gainInk,
            size: 30,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l10n.smsBridgePaired(device.label ?? device.deviceId),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: PosTokens.ink1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.smsBridgePairedBody,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            height: 1.4,
            color: PosTokens.ink2,
          ),
        ),
        const SizedBox(height: 18),
        _SecondaryButton(
          label: l10n.smsBridgePairAnother,
          onPressed: onPairAnother,
        ),
      ],
    );
  }
}

class _DeviceList extends StatelessWidget {
  const _DeviceList({required this.devices, required this.onRevoke});

  final List<SmsBridgeDevice> devices;
  final ValueChanged<SmsBridgeDevice> onRevoke;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final now = DateTime.now();
    final rows = <Widget>[];
    for (var i = 0; i < devices.length; i++) {
      final d = devices[i];
      final seen = d.lastSeenAt;
      // Live = forwarded within the hour; the bridge's own safety-net sweep
      // runs every 3 hours, so an idle phone is not a broken one.
      final dot = seen == null
          ? PosTokens.ink4
          : now.difference(seen) < const Duration(hours: 1)
          ? PosTokens.gain
          : PosTokens.ink3;
      if (i > 0) {
        rows.add(
          const Divider(
            height: 1,
            thickness: 0.6,
            indent: 52,
            color: PosTokens.line,
          ),
        );
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          child: Row(
            children: [
              const Icon(
                Icons.phone_android_rounded,
                color: PosTokens.ink3,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.label ?? d.deviceId,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: PosTokens.ink1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: dot,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            seen == null
                                ? l10n.smsBridgeNeverSeen
                                : l10n.smsBridgeLastSeen(
                                    DateFormat(
                                      'd MMM, HH:mm',
                                    ).format(seen.toLocal()),
                                  ),
                            style: const TextStyle(
                              fontSize: 13,
                              color: PosTokens.ink3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: PosTokens.lossInk),
                onPressed: () => onRevoke(d),
                child: Text(l10n.smsBridgeRevoke),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: PosTokens.surface,
        borderRadius: BorderRadius.circular(MposTokens.radiusMd),
        border: Border.all(color: PosTokens.line),
      ),
      child: Column(children: rows),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
  });

  final String label;
  final IconData? icon;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: PosTokens.blue,
          disabledBackgroundColor: PosTokens.blue.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: busy
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: PosTokens.blue,
          backgroundColor: PosTokens.blueTint,
          side: const BorderSide(color: PosTokens.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
