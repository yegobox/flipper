import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/bulk_rra_client.dart'
    show resolveDataConnectorBaseUrl;
import 'package:flipper_models/sms_bridge_client.dart';
import 'package:flipper_services/data_connector_url.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

const Color _kBlue = Color(0xFF2563EB);

/// Where phones download the bridge app (`.github/workflows/sms_bridge.yml`
/// attaches each signed APK to a `sms-bridge-v*` release).
const String kSmsBridgeDownloadUrl =
    'https://github.com/yegobox/flipper/releases?q=sms-bridge';

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

/// Settings → SMS Bridge: pair a phone that forwards bank and MoMo SMS, and
/// manage the ones already paired.
class SmsBridgePage extends ConsumerStatefulWidget {
  const SmsBridgePage({super.key});

  @override
  ConsumerState<SmsBridgePage> createState() => _SmsBridgePageState();
}

class _SmsBridgePageState extends ConsumerState<SmsBridgePage> {
  SmsBridgePairing? _pairing;
  bool _busy = false;
  String? _error;

  Future<void> _pair() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final pairing = await ref.read(smsBridgeClientProvider).createPairing();
      if (!mounted) return;
      setState(() => _pairing = pairing);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = context.flipperL10n.smsBridgeError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _revoke(SmsBridgeDevice device) async {
    final l10n = context.flipperL10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(l10n.smsBridgeRevokeConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _kBlue),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.smsBridgeRevoke),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(smsBridgeClientProvider).revoke(device.deviceId);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = l10n.smsBridgeError(e.toString()));
    }
    ref.invalidate(smsBridgeDevicesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final devices = ref.watch(smsBridgeDevicesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.smsBridgeTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.smsBridgeIntro, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 8),
          SelectableText(
            l10n.smsBridgeDownload(kSmsBridgeDownloadUrl),
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 16),
          if (_pairing == null)
            FilledButton.icon(
              key: const Key('sms_bridge_pair'),
              style: FilledButton.styleFrom(
                backgroundColor: _kBlue,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: _busy ? null : _pair,
              icon: const Icon(Icons.qr_code_2),
              label: Text(l10n.smsBridgePairPhone),
            )
          else
            _PairingCode(pairing: _pairing!, onNewCode: _pair),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Color(0xFFDC2626))),
          ],
          const SizedBox(height: 28),
          Text(
            l10n.smsBridgeDevices,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          devices.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (e, _) => Text(l10n.smsBridgeError(e.toString())),
            data: (list) => list.isEmpty
                ? Text(
                    l10n.smsBridgeNoDevices,
                    style: TextStyle(color: Colors.grey.shade700),
                  )
                : Column(
                    children: [
                      for (final d in list)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.phone_android),
                          title: Text(d.label ?? d.deviceId),
                          subtitle: Text(
                            d.lastSeenAt == null
                                ? l10n.smsBridgeNeverSeen
                                : l10n.smsBridgeLastSeen(
                                    DateFormat(
                                      'd MMM, HH:mm',
                                    ).format(d.lastSeenAt!.toLocal()),
                                  ),
                          ),
                          trailing: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: _kBlue,
                            ),
                            onPressed: () => _revoke(d),
                            child: Text(l10n.smsBridgeRevoke),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _PairingCode extends StatelessWidget {
  const _PairingCode({required this.pairing, required this.onNewCode});

  final SmsBridgePairing pairing;
  final VoidCallback onNewCode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final expires = DateFormat.Hm().format(pairing.expiresAt.toLocal());
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: _kBlue.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          QrImageView(
            key: const Key('sms_bridge_qr'),
            data: pairing.qrPayload,
            version: QrVersions.auto,
            size: 220,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(l10n.smsBridgeTypeCode),
          const SizedBox(height: 4),
          SelectableText(
            pairing.displayCode,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.smsBridgeCodeExpires(expires),
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: _kBlue,
              side: const BorderSide(color: _kBlue),
            ),
            onPressed: onNewCode,
            child: Text(l10n.smsBridgePairPhone),
          ),
        ],
      ),
    );
  }
}
