import 'package:flipper_dashboard/features/admin/mobile/settings_list.dart'
    show settingsPageAppBar;
import 'package:flipper_dashboard/features/online_shop/online_shop_items_section.dart';
import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart';
import 'package:flipper_dashboard/features/online_shop/online_shop_widgets.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/online_shop/online_shop_client.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_services/constants.dart' show AppFeature;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

/// Where shops live; the server returns the real URL once a slug exists.
const String kOnlineShopPublicBase = 'https://useflipper.com/shop/';

/// Settings → Online Shop: publish this branch's catalog on a public page
/// customers order from, and share its link.
class OnlineShopPage extends ConsumerWidget {
  const OnlineShopPage({super.key, this.canEdit});

  /// Whether the user may change settings. Null reads the Settings
  /// permission (write/admin); tests pass it.
  final bool? canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final bool editable =
        canEdit ??
        ref.watch(
              featureAccessProvider(
                userId: currentDashboardUserId(),
                featureName: AppFeature.Settings,
              ),
            ) ==
            true;
    final state = ref.watch(onlineShopStateProvider);
    return Scaffold(
      backgroundColor: MposTokens.bg,
      appBar: settingsPageAppBar(context, l10n.onlineShopTitle),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: state.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: PosTokens.blue),
              ),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.onlineShopError(e.toString()),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: PosTokens.lossInk),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: PosTokens.blue,
                        ),
                        onPressed: () =>
                            ref.invalidate(onlineShopStateProvider),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              ),
              data: (s) => OnlineShopForm(
                key: ValueKey(s.shop?.id ?? 'new'),
                initial: s,
                canEdit: editable,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The settings form. Holds its own edits; [initial] seeds it.
class OnlineShopForm extends ConsumerStatefulWidget {
  const OnlineShopForm({
    super.key,
    required this.initial,
    required this.canEdit,
  });

  final OnlineShopState initial;
  final bool canEdit;

  @override
  ConsumerState<OnlineShopForm> createState() => _OnlineShopFormState();
}

class _OnlineShopFormState extends ConsumerState<OnlineShopForm> {
  late OnlineShopState _state = widget.initial;
  late bool _enabled;
  late bool _showStock;
  late bool _pickup;
  late bool _delivery;
  final _name = TextEditingController();
  final _slug = TextEditingController();
  final _description = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _deliveryNote = TextEditingController();
  final _payCode = TextEditingController();
  final _momo = TextEditingController();
  final _airtel = TextEditingController();
  bool _busy = false;
  String? _error;
  String? _slugError;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    final s = widget.initial.shop ?? const OnlineShopSettings();
    _enabled = widget.initial.shop == null ? true : s.enabled;
    _showStock = s.showStock;
    _pickup = s.pickup;
    _delivery = s.delivery;
    _name.text = s.displayName;
    _slug.text = s.slug ?? '';
    _description.text = s.description ?? '';
    _phone.text = s.contactPhone ?? '';
    _whatsapp.text = s.whatsapp ?? '';
    _deliveryNote.text = s.deliveryNote ?? '';
    _payCode.text = s.momoPayCode ?? '';
    _momo.text = s.momoNumber ?? '';
    _airtel.text = s.airtelNumber ?? '';
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _slug,
      _description,
      _phone,
      _whatsapp,
      _deliveryNote,
      _payCode,
      _momo,
      _airtel,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  OnlineShopSettings get _draft => OnlineShopSettings(
    slug: _slug.text.trim(),
    enabled: _enabled,
    displayName: _name.text.trim(),
    description: _description.text,
    // No logo field here yet; keep the saved one, or the save clears it.
    logoUrl: _state.shop?.logoUrl,
    contactPhone: _phone.text,
    whatsapp: _whatsapp.text,
    showStock: _showStock,
    pickup: _pickup,
    delivery: _delivery,
    deliveryNote: _deliveryNote.text,
    momoPayCode: _payCode.text,
    momoNumber: _momo.text,
    airtelNumber: _airtel.text,
  );

  /// The slug the link will use: typed, else suggested from the name.
  String get _previewSlug {
    final typed = _slug.text.trim();
    return typed.isNotEmpty ? typed : suggestOnlineShopSlug(_name.text);
  }

  Future<void> _save() async {
    final l10n = context.flipperL10n;
    final slug = _slug.text.trim();
    setState(() {
      _error = null;
      _nameError = _name.text.trim().isEmpty
          ? l10n.onlineShopNameRequired
          : null;
      _slugError = slug.isNotEmpty && !isValidOnlineShopSlug(slug)
          ? l10n.onlineShopSlugInvalid
          : null;
    });
    if (_nameError != null || _slugError != null) return;
    final branchId = ref.read(onlineShopBranchIdProvider);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final saved = await ref
          .read(onlineShopClientProvider)
          .save(branchId, _draft);
      if (!mounted) return;
      setState(() {
        _state = saved;
        if (saved.shop?.slug != null) _slug.text = saved.shop!.slug!;
      });
      messenger.showSnackBar(SnackBar(content: Text(l10n.onlineShopSaved)));
    } on OnlineShopException catch (e) {
      if (!mounted) return;
      setState(() {
        if (e.slugTaken) {
          _slugError = l10n.onlineShopSlugTaken;
        } else if (e.code == 'invalid_slug' || e.statusCode == 400) {
          _slugError = l10n.onlineShopSlugInvalid;
        } else {
          _error = l10n.onlineShopError(e.message);
        }
      });
    } catch (e) {
      if (mounted) setState(() => _error = l10n.onlineShopError('$e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _copy(String url) async {
    final messenger = ScaffoldMessenger.of(context);
    final text = context.flipperL10n.onlineShopLinkCopied;
    await Clipboard.setData(ClipboardData(text: url));
    messenger.showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final edit = widget.canEdit && !_busy;
    final url = _state.url;
    final momoSet =
        _payCode.text.trim().isNotEmpty ||
        _momo.text.trim().isNotEmpty ||
        _airtel.text.trim().isNotEmpty;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        Text(
          l10n.onlineShopSubtitle,
          style: const TextStyle(
            fontSize: 14,
            height: 1.4,
            color: PosTokens.ink2,
          ),
        ),
        if (!widget.canEdit) ...[
          const SizedBox(height: 12),
          _Notice(text: l10n.onlineShopReadOnly),
        ],
        if (url != null) ...[
          const SizedBox(height: 16),
          _ShareCard(url: url, name: _name.text, onCopy: _copy),
        ],
        if (momoSet && !_state.smsBridgePaired) ...[
          const SizedBox(height: 12),
          _Notice(
            key: const Key('online_shop_sms_bridge_notice'),
            text: l10n.onlineShopSmsBridgeNotice,
          ),
        ],
        const SizedBox(height: 16),
        OnlineShopCard(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: _Switch(
            key: const Key('online_shop_enabled'),
            title: l10n.onlineShopEnabled,
            subtitle: l10n.onlineShopEnabledHint,
            value: _enabled,
            onChanged: edit ? (v) => setState(() => _enabled = v) : null,
          ),
        ),
        OnlineShopSectionLabel(l10n.onlineShopSectionDetails),
        OnlineShopCard(
          child: Column(
            children: [
              OnlineShopField(
                key: const Key('online_shop_name'),
                controller: _name,
                label: l10n.onlineShopDisplayName,
                enabled: edit,
                errorText: _nameError,
                onChanged: (_) => setState(() {}),
              ),
              OnlineShopField(
                key: const Key('online_shop_slug'),
                controller: _slug,
                label: l10n.onlineShopSlug,
                hint: '$kOnlineShopPublicBase$_previewSlug',
                enabled: edit,
                errorText: _slugError,
                onChanged: (_) => setState(() => _slugError = null),
              ),
              OnlineShopField(
                controller: _description,
                label: l10n.onlineShopDescription,
                enabled: edit,
                maxLines: 3,
              ),
              OnlineShopField(
                controller: _phone,
                label: l10n.onlineShopContactPhone,
                enabled: edit,
                keyboardType: TextInputType.phone,
              ),
              OnlineShopField(
                controller: _whatsapp,
                label: l10n.onlineShopWhatsapp,
                enabled: edit,
                keyboardType: TextInputType.phone,
              ),
              _Switch(
                title: l10n.onlineShopShowStock,
                subtitle: l10n.onlineShopShowStockHint,
                value: _showStock,
                onChanged: edit ? (v) => setState(() => _showStock = v) : null,
              ),
            ],
          ),
        ),
        OnlineShopSectionLabel(l10n.onlineShopSectionFulfilment),
        OnlineShopCard(
          child: Column(
            children: [
              _Switch(
                title: l10n.onlineShopPickup,
                value: _pickup,
                onChanged: edit ? (v) => setState(() => _pickup = v) : null,
              ),
              _Switch(
                title: l10n.onlineShopDelivery,
                value: _delivery,
                onChanged: edit ? (v) => setState(() => _delivery = v) : null,
              ),
              if (_delivery)
                OnlineShopField(
                  controller: _deliveryNote,
                  label: l10n.onlineShopDeliveryNote,
                  enabled: edit,
                  maxLines: 2,
                ),
            ],
          ),
        ),
        OnlineShopSectionLabel(l10n.onlineShopSectionPayment),
        OnlineShopCard(
          child: Column(
            children: [
              OnlineShopField(
                key: const Key('online_shop_paycode'),
                controller: _payCode,
                label: l10n.onlineShopMomoPayCode,
                enabled: edit,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              OnlineShopField(
                controller: _momo,
                label: l10n.onlineShopMomoNumber,
                enabled: edit,
                keyboardType: TextInputType.phone,
                onChanged: (_) => setState(() {}),
              ),
              OnlineShopField(
                controller: _airtel,
                label: l10n.onlineShopAirtelNumber,
                enabled: edit,
                keyboardType: TextInputType.phone,
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: PosTokens.lossInk)),
        ],
        if (widget.canEdit) ...[
          const SizedBox(height: 20),
          OnlineShopPrimaryButton(
            key: const Key('online_shop_save'),
            label: l10n.onlineShopSave,
            busy: _busy,
            onPressed: _save,
          ),
        ],
        if (_state.shop != null) ...[
          OnlineShopSectionLabel(l10n.onlineShopItems),
          OnlineShopItemsSection(
            hiddenVariantIds: _state.hiddenVariantIds,
            canEdit: widget.canEdit,
            onHiddenChanged: (ids) =>
                setState(() => _state = _state.copyWith(hiddenVariantIds: ids)),
          ),
        ],
      ],
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      activeTrackColor: PosTokens.blue,
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, color: PosTokens.ink1),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: const TextStyle(fontSize: 13, color: PosTokens.ink3),
            ),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PosTokens.warnTint,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: PosTokens.warnAmber,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: PosTokens.ink1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The public link with copy, share and a QR to print for the counter.
class _ShareCard extends StatelessWidget {
  const _ShareCard({
    required this.url,
    required this.name,
    required this.onCopy,
  });

  final String url;
  final String name;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return OnlineShopCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  url,
                  key: const Key('online_shop_url'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: PosTokens.ink1,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    TextButton.icon(
                      key: const Key('online_shop_copy'),
                      style: TextButton.styleFrom(
                        foregroundColor: PosTokens.blue,
                      ),
                      onPressed: () => onCopy(url),
                      icon: const Icon(Icons.link_rounded, size: 18),
                      label: Text(l10n.onlineShopCopyLink),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: PosTokens.blue,
                      ),
                      onPressed: () =>
                          Share.share(l10n.onlineShopShareText(name, url)),
                      icon: const Icon(Icons.ios_share_rounded, size: 18),
                      label: Text(l10n.onlineShopShare),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          QrImageView(
            key: const Key('online_shop_qr'),
            data: url,
            version: QrVersions.auto,
            size: 104,
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
