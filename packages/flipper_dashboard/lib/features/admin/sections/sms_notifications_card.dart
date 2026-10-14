import 'dart:async';

import 'package:flipper_dashboard/features/admin/sections/admin_style.dart';
import 'package:flipper_dashboard/providers/digital_receipt_provider.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/sms/sms_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/branch_sms_config.model.dart';

/// The branch's SMS / WhatsApp notification settings.
///
/// [compact] stacks the phone field under its label and drops the tinted
/// icon tiles, for the phone settings hub.
class SmsNotificationsCard extends ConsumerStatefulWidget {
  const SmsNotificationsCard({super.key, this.compact = false});

  final bool compact;

  @override
  ConsumerState<SmsNotificationsCard> createState() =>
      _SmsNotificationsCardState();
}

class _SmsNotificationsCardState extends ConsumerState<SmsNotificationsCard> {
  String? smsPhoneNumber;
  bool enableSmsNotification = false;
  bool enableWhatsappNotification = false;
  int whatsappProvider = WhatsAppChannel.openwa;
  late final TextEditingController phoneController;
  late final FocusNode _smsPhoneFocusNode;
  Timer? _smsPhoneDebounce;
  String? phoneError;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    _smsPhoneFocusNode = FocusNode();
    _smsPhoneFocusNode.addListener(() {
      if (!_smsPhoneFocusNode.hasFocus) {
        final phone = _normalizedSmsPhoneFromController();
        _scheduleSmsPhoneSave(phone);
      }
    });
    _loadSmsConfig();
  }

  @override
  void dispose() {
    _smsPhoneDebounce?.cancel();
    phoneController.dispose();
    _smsPhoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _updateSmsConfig({
    String? phone,
    bool? enableSms,
    bool? enableWhatsapp,
    int? whatsappProvider,
  }) async {
    if (phone != null && phone.isNotEmpty) {
      if (!adminIsValidPhoneNumber(phone)) {
        setState(() {
          phoneError = context.flipperL10n.adminPhoneWithCountryCode;
        });
        return;
      }
      phone = adminFormatPhoneNumber(phone);
    }

    try {
      await SmsNotificationService.updateBranchSmsConfig(
        branchId: ProxyService.box.getBranchId()!,
        smsPhoneNumber: phone,
        enableSms: enableSms,
        enableWhatsapp: enableWhatsapp,
        whatsappProvider: whatsappProvider,
      );

      if (!mounted) return;

      // branchSmsNotificationsEnabledProvider caches for the life of the app,
      // and it gates the POS digital-receipt toggle. Without this the checkout
      // screen keeps the stale value until a full restart.
      ref.invalidate(branchSmsNotificationsEnabledProvider);

      setState(() {
        if (phone != null) smsPhoneNumber = phone;
        if (enableSms != null) enableSmsNotification = enableSms;
        if (enableWhatsapp != null) {
          enableWhatsappNotification = enableWhatsapp;
        }
        if (whatsappProvider != null) {
          this.whatsappProvider = whatsappProvider;
        }
        phoneError = null;
      });
    } catch (e) {
      print('Error updating SMS config: $e');
      setState(() {
        phoneError = context.flipperL10n.adminSmsConfigFailed;
      });
    }
  }

  /// When enabling WhatsApp, prompt for OpenWA (1) vs Meta (2).
  Future<void> _onWhatsappEnabledChanged(bool enabled) async {
    if (!enabled) {
      await _updateSmsConfig(enableWhatsapp: false);
      return;
    }
    final channel = await _promptWhatsAppChannel(initial: whatsappProvider);
    if (!mounted || channel == null) return;
    await _updateSmsConfig(enableWhatsapp: true, whatsappProvider: channel);
  }

  Future<int?> _promptWhatsAppChannel({required int initial}) {
    var selected = initial == WhatsAppChannel.meta
        ? WhatsAppChannel.meta
        : WhatsAppChannel.openwa;
    return showDialog<int>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text(
                context.flipperL10n.adminWhatsappChannel,
                style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.flipperL10n.adminWhatsappChannelHint,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<int>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'OpenWA',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      context.flipperL10n.adminOpenWaSubtitle,
                      style: GoogleFonts.outfit(fontSize: 12),
                    ),
                    value: WhatsAppChannel.openwa,
                    groupValue: selected,
                    onChanged: (v) {
                      if (v == null) return;
                      setDialogState(() => selected = v);
                    },
                  ),
                  RadioListTile<int>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Meta Cloud API',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      context.flipperL10n.adminMetaSubtitle,
                      style: GoogleFonts.outfit(fontSize: 12),
                    ),
                    value: WhatsAppChannel.meta,
                    groupValue: selected,
                    onChanged: (v) {
                      if (v == null) return;
                      setDialogState(() => selected = v);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(context.flipperL10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(selected),
                  child: Text(context.flipperL10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String? _normalizedSmsPhoneFromController() {
    final raw = phoneController.text.trim();
    return raw.isEmpty ? null : raw;
  }

  void _scheduleSmsPhoneSave(String? phone) {
    _smsPhoneDebounce?.cancel();
    _smsPhoneDebounce = Timer(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      _updateSmsConfig(phone: phone);
    });
  }

  Future<void> _loadSmsConfig() async {
    try {
      final config = await SmsNotificationService.getBranchSmsConfig(
        ProxyService.box.getBranchId()!,
      );
      if (config != null) {
        setState(() {
          smsPhoneNumber = config.smsPhoneNumber;
          enableSmsNotification = config.enableSms;
          enableWhatsappNotification = config.enableWhatsapp;
          whatsappProvider = config.whatsappProvider;
          phoneController.text = config.smsPhoneNumber ?? '';
        });
      }
    } catch (e) {
      print('Error loading SMS config: $e');
    }
  }

  Widget _phoneRow(BuildContext context) {
    final label = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.flipperL10n.adminSmsPhoneNumber,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: kAdminTitleText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.flipperL10n.adminSmsPhoneHint,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: kAdminSubtitleText,
            height: 1.35,
          ),
        ),
      ],
    );
    final field = TextField(
      controller: phoneController,
      focusNode: _smsPhoneFocusNode,
      style: GoogleFonts.outfit(fontSize: 14),
      decoration: InputDecoration(
        hintText: context.flipperL10n.enterPhoneNumber,
        hintStyle: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        errorText: phoneError,
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kAdminBarBlue, width: 1.2),
        ),
      ),
      onChanged: (value) {
        setState(() {
          smsPhoneNumber = value.isEmpty ? null : value;
          phoneError = null;
        });
        _scheduleSmsPhoneSave(value.trim().isEmpty ? null : value.trim());
      },
      onSubmitted: (value) {
        final phone = value.isEmpty ? null : value;
        _updateSmsConfig(phone: phone);
      },
      onEditingComplete: () {
        final phone = _normalizedSmsPhoneFromController();
        _updateSmsConfig(phone: phone);
      },
    );
    if (widget.compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [label, const SizedBox(height: 12), field],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminLeadingSvg(
          AdminDashboardSvgs.smsPhone,
          kAdminBarTeal.withValues(alpha: 0.1),
        ),
        const SizedBox(width: 14),
        Expanded(child: label),
        const SizedBox(width: 12),
        SizedBox(width: 200, child: field),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: adminCardDecoration(),
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: _phoneRow(context)),
          Divider(height: 1, thickness: 1, color: kAdminCardBorder),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AdminSwitchRow(
              title: context.flipperL10n.enableSmsNotifications,
              subtitle: context.flipperL10n.receiveSmsNotificationsForOrders,
              leading: widget.compact
                  ? null
                  : adminLeadingSvg(
                      AdminDashboardSvgs.enableNotifications,
                      const Color(0xFF16A34A).withValues(alpha: 0.1),
                    ),
              value: enableSmsNotification,
              onChanged: (value) => _updateSmsConfig(enableSms: value),
            ),
          ),
          Divider(height: 1, thickness: 1, color: kAdminCardBorder),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AdminSwitchRow(
              title: context.flipperL10n.enableWhatsappNotifications,
              subtitle:
                  context.flipperL10n.receiveWhatsappNotificationsForOrders,
              leading: widget.compact
                  ? null
                  : adminLeadingSvg(
                      AdminDashboardSvgs.enableNotifications,
                      const Color(0xFF25D366).withValues(alpha: 0.12),
                    ),
              value: enableWhatsappNotification,
              onChanged: _onWhatsappEnabledChanged,
            ),
          ),
          if (enableWhatsappNotification) ...[
            Divider(height: 1, thickness: 1, color: kAdminCardBorder),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.flipperL10n.adminDefaultWhatsappChannel,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: kAdminTitleText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '1 = OpenWA · 2 = Meta Cloud API',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: kAdminSubtitleText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment<int>(
                        value: WhatsAppChannel.openwa,
                        label: Text('OpenWA'),
                        icon: Icon(Icons.smartphone_outlined, size: 16),
                      ),
                      ButtonSegment<int>(
                        value: WhatsAppChannel.meta,
                        label: Text('Meta'),
                        icon: Icon(Icons.cloud_outlined, size: 16),
                      ),
                    ],
                    selected: {
                      whatsappProvider == WhatsAppChannel.meta
                          ? WhatsAppChannel.meta
                          : WhatsAppChannel.openwa,
                    },
                    onSelectionChanged: (set) {
                      final v = set.first;
                      _updateSmsConfig(whatsappProvider: v);
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
