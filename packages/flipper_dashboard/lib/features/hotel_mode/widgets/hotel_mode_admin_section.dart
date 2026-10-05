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
import 'package:flipper_dashboard/services/stamp_ink.dart';
import 'package:flipper_dashboard/utils/pick_image_base64.dart';
import 'package:flipper_localize/flipper_localize.dart';
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
  BranchDocumentSettings _documents = const BranchDocumentSettings(
    branchId: '',
  );
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
        context.flipperL10n.hotelModeAlongsideBar,
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
          dialogContext.flipperL10n.hotelHouseCheckoutTime,
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
    final l10n = context.flipperL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BarAdminEyebrow(label: l10n.hotelAdminLodging),
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
                    title: l10n.hotelAutoPostTitle,
                    subtitle: l10n.hotelAutoPostSubtitle,
                    value: _autoPostRoomCharge,
                    onChanged: (v) {
                      setState(() => _autoPostRoomCharge = v);
                      HotelModeSettings.setAutoPostRoomCharge(v);
                    },
                  ),
                  BarSubRow(
                    icon: Icons.lock_outline,
                    title: l10n.hotelRequirePinTitle,
                    subtitle: l10n.hotelRequirePinSubtitle,
                    value: _requirePin,
                    onChanged: (v) {
                      setState(() => _requirePin = v);
                      HotelModeSettings.setRequirePin(v);
                    },
                  ),
                  BarSubRow(
                    icon: Icons.shield_outlined,
                    title: l10n.hotelManagerCheckoutTitle,
                    subtitle: l10n.hotelManagerCheckoutSubtitle,
                    value: _managerCheckout,
                    onChanged: (v) {
                      setState(() => _managerCheckout = v);
                      HotelModeSettings.setManagerCheckout(v);
                    },
                  ),
                  BarSubRow(
                    icon: Icons.logout,
                    title: l10n.hotelAutoLogoutTitle,
                    subtitle: l10n.hotelAutoLogoutSubtitle,
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
          BarAdminEyebrow(label: l10n.hotelAdminRoomsFloors),
          const HotelRoomPlanEditor(),
          const SizedBox(height: 22),
          BarAdminEyebrow(
            label: l10n.hotelAdminRatesBilling,
            accent: HotelTokens.reservedInk,
          ),
          BarCard(
            child: Column(
              children: [
                _actionRow(
                  icon: Icons.sell_outlined,
                  title: l10n.hotelRoomChargeProduct,
                  subtitle: _roomChargeSubtitle(l10n),
                  warn: _roomChargeVariantId == null,
                  showTopBorder: false,
                  onTap: _pickRoomChargeProduct,
                ),
                _actionRow(
                  icon: Icons.schedule,
                  title: l10n.hotelHouseCheckoutTime,
                  subtitle: l10n.hotelCheckoutDefaultSubtitle(
                    '${_checkOutHour.toString().padLeft(2, '0')}:00',
                  ),
                  onTap: _pickCheckOutHour,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          BarAdminEyebrow(label: l10n.hotelAdminGuestNotifications),
          _guestNotificationsCard(l10n),
          const SizedBox(height: 22),
          BarAdminEyebrow(label: l10n.hotelAdminCompanyStamp),
          _stampCard(l10n),
        ],
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BarPrimaryButton(
              label: l10n.hotelOpenFrontDesk,
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

  String _roomChargeSubtitle(FlipperAppLocalizations l10n) {
    if (_loadingVariant) return l10n.hotelLoading;
    final variant = _roomChargeVariant;
    final variantId = _roomChargeVariantId;
    if (variantId == null) {
      return l10n.hotelRoomChargeNotSet;
    }
    if (variant == null) {
      return l10n.hotelRoomChargeMissing(variantId);
    }
    return '${variant.name} · RWF '
        '${NumberFormat('#,###').format(variant.retailPrice ?? 0)}';
  }

  Widget _guestNotificationsCard(FlipperAppLocalizations l10n) {
    return BarCard(
      child: Column(
        children: [
          BarSubRow(
            showTopBorder: false,
            icon: Icons.mail_outline,
            title: l10n.hotelNotifyEmailTitle,
            subtitle: l10n.hotelNotifyEmailSubtitle,
            value: _notifyGuestEmail,
            onChanged: (v) {
              setState(() => _notifyGuestEmail = v);
              HotelModeSettings.setNotifyGuestEmail(v);
            },
          ),
          BarSubRow(
            icon: Icons.sms_outlined,
            title: l10n.hotelNotifySmsTitle,
            subtitle: l10n.hotelNotifySmsSubtitle,
            value: _notifyGuestSms,
            onChanged: (v) {
              setState(() => _notifyGuestSms = v);
              HotelModeSettings.setNotifyGuestSms(v);
            },
          ),
          BarSubRow(
            icon: Icons.event_available_outlined,
            title: l10n.hotelNotifyReserveTitle,
            subtitle: l10n.hotelNotifyReserveSubtitle,
            value: _notifyOnReserve,
            onChanged: (v) {
              setState(() => _notifyOnReserve = v);
              HotelModeSettings.setNotifyOnReserve(v);
            },
          ),
          BarSubRow(
            icon: Icons.login,
            title: l10n.hotelNotifyCheckInTitle,
            subtitle: l10n.hotelNotifyCheckInSubtitle,
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

  Widget _stampCard(FlipperAppLocalizations l10n) {
    final stampBytes = _decodedStamp();

    return BarCard(
      child: Column(
        children: [
          BarSubRow(
            showTopBorder: false,
            icon: Icons.approval_outlined,
            title: l10n.hotelStampTitle,
            subtitle: stampBytes == null
                ? l10n.hotelStampUploadFirst
                : l10n.hotelStampDrawnOn,
            value: _documents.stampEnabled,
            onChanged: (v) =>
                _persistDocuments(_documents.copyWith(stampEnabled: v)),
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
                              l10n.hotelNoStamp,
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
                                  l10n.hotelStampUnreadable,
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
                            l10n.hotelStampSizeHint(
                              '${BranchDocumentSettings.maxStampBytes ~/ 1024}',
                            ),
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
                                  stampBytes == null
                                      ? l10n.hotelUpload
                                      : l10n.hotelReplace,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (stampBytes != null)
                                TextButton(
                                  onPressed: _updatingStamp
                                      ? null
                                      : _removeStamp,
                                  child: Text(
                                    l10n.remove,
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
                  _stampPlacementRow(l10n),
                  const SizedBox(height: 8),
                  _stampWidthRow(l10n),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stampPlacementRow(FlipperAppLocalizations l10n) {
    final labels = {
      DocumentStampPlacement.bottomRight: l10n.hotelStampBottomRight,
      DocumentStampPlacement.bottomLeft: l10n.hotelStampBottomLeft,
      DocumentStampPlacement.bottomCentre: l10n.hotelStampBottomCentre,
      DocumentStampPlacement.besideTotals: l10n.hotelStampBesideTotal,
    };

    return Row(
      children: [
        Text(
          l10n.hotelStampPosition,
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

  Widget _stampWidthRow(FlipperAppLocalizations l10n) {
    return Row(
      children: [
        Text(
          l10n.hotelStampWidth,
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
      // Preview what will print, not the raw photo.
      return inkifyStamp(base64Decode(encoded));
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
      final ok = await _persistDocuments(
        _documents.copyWith(
          stampImageBase64: picked.image!.base64,
          stampAspectRatio: picked.image!.aspectRatio,
          stampEnabled: true,
        ),
        notify: false,
      );

      if (!mounted) return;
      if (ok) {
        showSuccessNotification(context, context.flipperL10n.hotelStampUpdated);
      } else {
        showErrorNotification(
          context,
          context.flipperL10n.hotelStampSavedLocalOnly,
        );
      }
    } catch (e) {
      if (mounted) {
        showErrorNotification(
          context,
          context.flipperL10n.hotelStampSetFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _updatingStamp = false);
    }
  }

  Future<void> _removeStamp() async {
    setState(() => _updatingStamp = true);
    try {
      final ok = await _persistDocuments(
        _documents.copyWith(clearStampImage: true, stampEnabled: false),
        notify: false,
      );
      if (!mounted) return;
      if (ok) {
        showSuccessNotification(context, context.flipperL10n.hotelStampRemoved);
      } else {
        showErrorNotification(
          context,
          context.flipperL10n.hotelStampRemovedLocalOnly,
        );
      }
    } finally {
      if (mounted) setState(() => _updatingStamp = false);
    }
  }

  /// Returns whether the branch document actually persisted, so a caller does
  /// not announce a stamp that only exists on this device.
  Future<bool> _persistDocuments(
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
      showErrorNotification(
        context,
        context.flipperL10n.hotelStampSavedDeviceOnly,
      );
    }
    return ok;
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
            const Icon(Icons.chevron_right, size: 20, color: HotelTokens.ink3),
          ],
        ),
      ),
    );
  }

  Widget _heroCard() {
    final l10n = context.flipperL10n;
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
                        l10n.hotelModeTitle,
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
                          l10n.hotelOnBadge,
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
                  l10n.hotelModeDescription(serviceModeHotkeyLabel),
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
