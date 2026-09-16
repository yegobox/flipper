import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/service_mode_hotkey.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_room_charge_picker.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_room_plan_editor.dart';
import 'package:flipper_dashboard/utils/pick_image_base64.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/branch_document_settings.dart';
import 'package:flipper_models/services/branch_document_settings_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// Hotel Mode (front desk) section for [AdminControl].
///
/// Reuses the Bar Mode admin chrome ([BarCard], [BarSubRow], [BarToggle], …):
/// those are generic settings-page primitives that happen to live in the bar
/// folder, and duplicating them here would put the same switch in two places.
class HotelModeAdminSection extends StatefulWidget {
  const HotelModeAdminSection({super.key});

  @override
  State<HotelModeAdminSection> createState() => _HotelModeAdminSectionState();
}

class _HotelModeAdminSectionState extends State<HotelModeAdminSection> {
  bool _enabled = false;
  bool _autoPostRoomCharge = true;
  bool _managerCheckout = true;
  bool _requirePin = true;
  bool _autoLogout = false;
  int _checkOutHour = 11;
  String? _roomChargeVariantId;
  Variant? _roomChargeVariant;
  bool _loadingVariant = false;
  bool _notifyGuestSms = false;
  bool _notifyGuestEmail = true;
  bool _notifyOnReserve = true;
  bool _notifyOnCheckIn = true;
  BranchDocumentSettings _documents = const BranchDocumentSettings(branchId: '');
  bool _updatingStamp = false;

  @override
  void initState() {
    super.initState();
    serviceModeRevision.addListener(_onServiceModeChanged);
    _syncFromLocalCache();
    _loadSettings();
  }

  @override
  void dispose() {
    serviceModeRevision.removeListener(_onServiceModeChanged);
    super.dispose();
  }

  /// The sibling Bar section may have just turned Hotel Mode off.
  void _onServiceModeChanged() {
    if (mounted) setState(_syncFromLocalCache);
  }

  void _syncFromLocalCache() {
    _enabled = HotelModeSettings.enabled;
    _autoPostRoomCharge = HotelModeSettings.autoPostRoomCharge;
    _managerCheckout = HotelModeSettings.managerCheckout;
    _requirePin = HotelModeSettings.requirePin;
    _autoLogout = HotelModeSettings.autoLogout;
    _checkOutHour = HotelModeSettings.checkOutHour;
    _roomChargeVariantId = HotelModeSettings.roomChargeVariantId;
    _notifyGuestSms = HotelModeSettings.notifyGuestSms;
    _notifyGuestEmail = HotelModeSettings.notifyGuestEmail;
    _notifyOnReserve = HotelModeSettings.notifyOnReserve;
    _notifyOnCheckIn = HotelModeSettings.notifyOnCheckIn;
    _documents = BranchDocumentSettingsService.current();
  }

  Future<void> _loadSettings() async {
    await HotelModeSettings.hydrateForActiveBranch();
    if (!mounted) return;
    setState(_syncFromLocalCache);
    HotelModeSettings.startWatchingActiveBranch();
    await _loadRoomChargeVariant();
  }

  Future<void> _loadRoomChargeVariant() async {
    final id = _roomChargeVariantId;
    if (id == null) {
      if (mounted) setState(() => _roomChargeVariant = null);
      return;
    }
    setState(() => _loadingVariant = true);
    try {
      final variant = await ProxyService.getStrategy(
        Strategy.capella,
      ).getVariant(id: id);
      if (!mounted) return;
      setState(() {
        _roomChargeVariant = variant;
        _loadingVariant = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingVariant = false);
    }
  }

  Future<void> _onMasterToggle(bool value) async {
    setState(() => _enabled = value);
    HotelModeSettings.setEnabled(value);
    notifyServiceModeChanged();

    if (!value) return;

    // A property can offer both. Which surface a given terminal shows is a
    // device choice, so turning the desk on no longer shuts the bar down.
    if (BarModeSettings.enabled && mounted) {
      showCustomSnackBarUtil(
        context,
        'Hotel Mode on alongside Bar Mode — pick what this device runs below.',
      );
    }

    final branchId = ProxyService.box.getBranchId();
    if (branchId != null) {
      await ProxyService.getStrategy(
        Strategy.capella,
      ).seedDefaultRooms(branchId: branchId);
    }
  }

  Future<void> _pickRoomChargeProduct() async {
    final variant = await HotelRoomChargePicker.show(
      context,
      selectedVariantId: _roomChargeVariantId,
    );
    if (variant == null) return;
    setState(() {
      _roomChargeVariantId = variant.id;
      _roomChargeVariant = variant;
    });
    HotelModeSettings.setRoomChargeVariantId(variant.id);
  }

  Future<void> _pickCheckOutHour() async {
    final picked = await showDialog<int>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(
          'House checkout time',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        children: [
          for (var hour = 6; hour <= 18; hour++)
            SimpleDialogOption(
              onPressed: () => Navigator.of(dialogContext).pop(hour),
              child: Row(
                children: [
                  Icon(
                    hour == _checkOutHour
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    size: 18,
                    color: HotelTokens.ink2,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${hour.toString().padLeft(2, '0')}:00',
                    style: GoogleFonts.jetBrainsMono(fontSize: 14),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
    if (picked == null) return;
    setState(() => _checkOutHour = picked);
    HotelModeSettings.setCheckOutHour(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BarAdminEyebrow(label: 'Lodging'),
        _heroCard(),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: BarCard(
              child: Column(
                children: [
                  BarSubRow(
                    showTopBorder: false,
                    icon: Icons.receipt_long_outlined,
                    title: 'Post the room charge at check-in',
                    subtitle:
                        'Bills nights × rate to the folio as soon as the guest takes the key.',
                    value: _autoPostRoomCharge,
                    onChanged: (v) {
                      setState(() => _autoPostRoomCharge = v);
                      HotelModeSettings.setAutoPostRoomCharge(v);
                    },
                  ),
                  BarSubRow(
                    icon: Icons.lock_outline,
                    title: 'Require PIN to switch clerk',
                    subtitle:
                        'Shared register: the desk opens on a PIN lock and any staff member can sign in.',
                    value: _requirePin,
                    onChanged: (v) {
                      setState(() => _requirePin = v);
                      HotelModeSettings.setRequirePin(v);
                    },
                  ),
                  BarSubRow(
                    icon: Icons.shield_outlined,
                    title: 'Manager required to settle a folio',
                    subtitle:
                        'Only a manager can take payment and release the room at checkout.',
                    value: _managerCheckout,
                    onChanged: (v) {
                      setState(() => _managerCheckout = v);
                      HotelModeSettings.setManagerCheckout(v);
                    },
                  ),
                  BarSubRow(
                    icon: Icons.logout,
                    title: 'Hand the desk back after checkout',
                    subtitle:
                        'Returns to the PIN lock once a guest is checked out.',
                    value: _autoLogout,
                    onChanged: (v) {
                      setState(() => _autoLogout = v);
                      HotelModeSettings.setAutoLogout(v);
                    },
                  ),
                ],
              ),
            ),
          ),
          crossFadeState: _enabled
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 280),
        ),
        if (_enabled) ...[
          const SizedBox(height: 22),
          const BarAdminEyebrow(label: 'Rooms & floors'),
          const HotelRoomPlanEditor(),
          const SizedBox(height: 22),
          const BarAdminEyebrow(
            label: 'Rates & billing',
            accent: HotelTokens.reservedInk,
          ),
          BarCard(
            child: Column(
              children: [
                _actionRow(
                  icon: Icons.sell_outlined,
                  title: 'Room charge product',
                  subtitle: _roomChargeSubtitle(),
                  warn: _roomChargeVariantId == null,
                  showTopBorder: false,
                  onTap: _pickRoomChargeProduct,
                ),
                _actionRow(
                  icon: Icons.schedule,
                  title: 'House checkout time',
                  subtitle:
                      'Departure defaults to ${_checkOutHour.toString().padLeft(2, '0')}:00 on the last night.',
                  onTap: _pickCheckOutHour,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const BarAdminEyebrow(label: 'Guest notifications'),
          _guestNotificationsCard(),
          const SizedBox(height: 22),
          const BarAdminEyebrow(label: 'Company stamp'),
          _stampCard(),
        ],
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BarPrimaryButton(
              label: 'Open the front desk',
              onPressed: _enabled
                  ? () {
                      HotelModeSettings.setLaunchOnStart(true);
                      locator<RouterService>().navigateTo(HotelModeHostRoute());
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  String _roomChargeSubtitle() {
    if (_loadingVariant) return 'Loading…';
    final variant = _roomChargeVariant;
    if (_roomChargeVariantId == null) {
      return 'Not set — room charges cannot be posted until you pick a registered product.';
    }
    if (variant == null) {
      return 'Product $_roomChargeVariantId is no longer on this branch. Pick another.';
    }
    return '${variant.name} · RWF '
        '${NumberFormat('#,###').format(variant.retailPrice ?? 0)}';
  }

  Widget _guestNotificationsCard() {
    return BarCard(
      child: Column(
        children: [
          BarSubRow(
            showTopBorder: false,
            icon: Icons.mail_outline,
            title: 'Email the guest a confirmation',
            subtitle: 'Free. Sent whenever the guest gave an email address.',
            value: _notifyGuestEmail,
            onChanged: (v) {
              setState(() => _notifyGuestEmail = v);
              HotelModeSettings.setNotifyGuestEmail(v);
            },
          ),
          BarSubRow(
            icon: Icons.sms_outlined,
            title: 'Text the guest a confirmation',
            subtitle:
                'Costs 30 credits per message. Off until you turn it on.',
            value: _notifyGuestSms,
            onChanged: (v) {
              setState(() => _notifyGuestSms = v);
              HotelModeSettings.setNotifyGuestSms(v);
            },
          ),
          BarSubRow(
            icon: Icons.event_available_outlined,
            title: 'Confirm when a room is held',
            subtitle: 'Sent at the moment a future arrival is booked in.',
            value: _notifyOnReserve,
            onChanged: (v) {
              setState(() => _notifyOnReserve = v);
              HotelModeSettings.setNotifyOnReserve(v);
            },
          ),
          BarSubRow(
            icon: Icons.login,
            title: 'Welcome the guest at check-in',
            subtitle: 'Sent when the guest actually takes the key.',
            value: _notifyOnCheckIn,
            onChanged: (v) {
              setState(() => _notifyOnCheckIn = v);
              HotelModeSettings.setNotifyOnCheckIn(v);
            },
          ),
        ],
      ),
    );
  }

  Widget _stampCard() {
    final stampBytes = _decodedStamp();

    return BarCard(
      child: Column(
        children: [
          BarSubRow(
            showTopBorder: false,
            icon: Icons.approval_outlined,
            title: 'Stamp quotations and proformas',
            subtitle: stampBytes == null
                ? 'Upload a stamp below, then turn this on.'
                : 'Drawn on the last page of every generated document.',
            value: _documents.stampEnabled,
            onChanged: (v) => _persistDocuments(
              _documents.copyWith(stampEnabled: v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 108,
                      height: 84,
                      decoration: BoxDecoration(
                        color: HotelTokens.posBg,
                        borderRadius: BorderRadius.circular(
                          HotelTokens.radiusMd,
                        ),
                        border: Border.all(color: HotelTokens.line),
                      ),
                      alignment: Alignment.center,
                      child: stampBytes == null
                          ? Text(
                              'No stamp',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: HotelTokens.ink4,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(6),
                              child: Image.memory(
                                stampBytes,
                                fit: BoxFit.contain,
                                // A stamp that will not decode must not take
                                // the whole settings page down with it.
                                errorBuilder: (_, __, ___) => Text(
                                  'Unreadable',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: HotelTokens.lossInk,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PNG or JPEG under '
                            '${BranchDocumentSettings.maxStampBytes ~/ 1024}KB. '
                            'A transparent PNG looks best.',
                            style: GoogleFonts.outfit(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: HotelTokens.ink3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              TextButton(
                                onPressed: _updatingStamp ? null : _pickStamp,
                                child: Text(
                                  stampBytes == null ? 'Upload' : 'Replace',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (stampBytes != null)
                                TextButton(
                                  onPressed:
                                      _updatingStamp ? null : _removeStamp,
                                  child: Text(
                                    'Remove',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: HotelTokens.lossInk,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (stampBytes != null) ...[
                  const SizedBox(height: 12),
                  _stampPlacementRow(),
                  const SizedBox(height: 8),
                  _stampWidthRow(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stampPlacementRow() {
    const labels = {
      DocumentStampPlacement.bottomRight: 'Bottom right',
      DocumentStampPlacement.bottomLeft: 'Bottom left',
      DocumentStampPlacement.bottomCentre: 'Bottom centre',
      DocumentStampPlacement.besideTotals: 'Beside the total',
    };

    return Row(
      children: [
        Text(
          'Position',
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: HotelTokens.ink2,
          ),
        ),
        const Spacer(),
        DropdownButton<DocumentStampPlacement>(
          value: _documents.stampPlacement,
          underline: const SizedBox.shrink(),
          style: GoogleFonts.outfit(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: HotelTokens.ink1,
          ),
          items: [
            for (final entry in labels.entries)
              DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          ],
          onChanged: (value) {
            if (value == null) return;
            _persistDocuments(_documents.copyWith(stampPlacement: value));
          },
        ),
      ],
    );
  }

  Widget _stampWidthRow() {
    return Row(
      children: [
        Text(
          'Width',
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: HotelTokens.ink2,
          ),
        ),
        Expanded(
          child: Slider(
            value: _documents.stampWidthMm.clamp(
              BranchDocumentSettings.minStampWidthMm,
              BranchDocumentSettings.maxStampWidthMm,
            ),
            min: BranchDocumentSettings.minStampWidthMm,
            max: BranchDocumentSettings.maxStampWidthMm,
            divisions: 8,
            label: '${_documents.stampWidthMm.round()} mm',
            // Only persist on release: dragging fires this continuously, and
            // every change is a Ditto write replicated to the whole branch.
            onChanged: (value) => setState(
              () => _documents = _documents.copyWith(stampWidthMm: value),
            ),
            onChangeEnd: (value) =>
                _persistDocuments(_documents.copyWith(stampWidthMm: value)),
          ),
        ),
        Text(
          '${_documents.stampWidthMm.round()} mm',
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: HotelTokens.ink3,
          ),
        ),
      ],
    );
  }

  Uint8List? _decodedStamp() {
    final encoded = _documents.stampImageBase64;
    if (encoded == null || encoded.isEmpty) return null;
    try {
      return base64Decode(encoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickStamp() async {
    setState(() => _updatingStamp = true);
    try {
      final picked = await pickImageAsBase64(
        maxSizeBytes: BranchDocumentSettings.maxStampBytes,
      );
      if (!mounted) return;

      if (picked.image == null) {
        if (!picked.cancelled) showErrorNotification(context, picked.message!);
        return;
      }

      // Turning the stamp on with the upload is what the clerk meant; making
      // them find a second switch afterwards is the kind of step people miss
      // and then report as "the stamp does not work".
      await _persistDocuments(
        _documents.copyWith(
          stampImageBase64: picked.image!.base64,
          stampAspectRatio: picked.image!.aspectRatio,
          stampEnabled: true,
        ),
        notify: false,
      );

      if (mounted) showSuccessNotification(context, 'Company stamp updated.');
    } catch (e) {
      if (mounted) showErrorNotification(context, 'Failed to set stamp: $e');
    } finally {
      if (mounted) setState(() => _updatingStamp = false);
    }
  }

  Future<void> _removeStamp() async {
    setState(() => _updatingStamp = true);
    try {
      await _persistDocuments(
        _documents.copyWith(clearStampImage: true, stampEnabled: false),
        notify: false,
      );
      if (mounted) showSuccessNotification(context, 'Company stamp removed.');
    } finally {
      if (mounted) setState(() => _updatingStamp = false);
    }
  }

  Future<void> _persistDocuments(
    BranchDocumentSettings next, {
    bool notify = true,
  }) async {
    final branchId = ProxyService.box.getBranchId() ?? '';
    final withBranch = next.copyWith(branchId: branchId);
    // Optimistic: the cache write inside persist() is what every PDF builder
    // reads, so the UI and the documents agree even if Ditto is slow.
    setState(() => _documents = withBranch);
    final ok = await BranchDocumentSettingsService.persist(withBranch);
    if (!ok && mounted && notify) {
      showErrorNotification(context, 'Stamp saved on this device only.');
    }
  }

  Widget _actionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showTopBorder = true,
    bool warn = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          border: showTopBorder
              ? const Border(top: BorderSide(color: HotelTokens.line))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: warn ? HotelTokens.dirtyInk : HotelTokens.ink2,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: HotelTokens.ink1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 12.5,
                      height: 1.35,
                      color: warn ? HotelTokens.dirtyInk : HotelTokens.ink3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: HotelTokens.ink3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
      decoration: BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
        border: Border.all(
          color: _enabled ? HotelTokens.blue : HotelTokens.line,
          width: 1.5,
        ),
        boxShadow: _enabled
            ? [
                BoxShadow(
                  color: HotelTokens.blue.withValues(alpha: 0.08),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : HotelTokens.shadow1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _enabled ? HotelTokens.blue : HotelTokens.blueTint,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.hotel_outlined,
              color: _enabled ? Colors.white : HotelTokens.blue,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Hotel Mode (Front Desk)',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: -0.18,
                          color: HotelTokens.ink1,
                        ),
                      ),
                    ),
                    if (_enabled) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: HotelTokens.vacantTint,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'ON',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: HotelTokens.vacantInk,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Turns the register into a front desk: a board of rooms by floor, '
                  'check-in with guest and dates, a running folio per stay that the '
                  'bar and restaurant can charge to, and settlement at checkout. '
                  'Replaces Bar Mode and standard retail checkout on this branch. '
                  'On a keyboard, $serviceModeHotkeyLabel cycles '
                  'Bar → Hotel → POS without coming back here.',
                  style: GoogleFonts.outfit(
                    fontSize: 13.5,
                    color: HotelTokens.ink2,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          BarToggle(value: _enabled, onChanged: _onMasterToggle),
        ],
      ),
    );
  }
}
