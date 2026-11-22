import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/config/system_config_tokens.dart';
import 'package:flipper_dashboard/features/config/widgets/config_chrome.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/branch_document_settings.dart';
import 'package:flipper_models/services/branch_document_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Where the receipt header is read from and saved to. A seam so the dialog
/// can be tested without Ditto; production goes through
/// [BranchDocumentSettingsService], which also keeps the print cache current.
class ReceiptHeaderStore {
  const ReceiptHeaderStore();

  Future<BranchDocumentSettings> load(String branchId) =>
      BranchDocumentSettingsService.loadForBranch(branchId);

  /// Writes the receipt header only; the stamp is never touched.
  Future<bool> save(BranchDocumentSettings settings) =>
      BranchDocumentSettingsService.saveReceiptHeader(settings);
}

final receiptHeaderStoreProvider = Provider<ReceiptHeaderStore>(
  (ref) => const ReceiptHeaderStore(),
);

/// Loose on purpose: receipts only need something a customer can dial.
/// Digits plus the usual separators, and at least 9 digits.
bool isValidReceiptPhone(String value) {
  final trimmed = value.trim();
  if (!RegExp(r'^\+?[0-9 ()\-]+$').hasMatch(trimmed)) return false;
  return trimmed.replaceAll(RegExp(r'[^0-9]'), '').length >= 9;
}

bool isValidReceiptEmail(String value) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());

/// Receipt header: the phone, email and welcome line printed at the top of
/// every receipt from [branchId] (the active branch when null). Shown in Tax
/// Settings and in System Configuration.
///
/// Phone and email are required, so a saved header can never print a bare
/// `TEL:` or `EMAIL:`. They start from the business's own details when the
/// branch has not set any.
class ReceiptHeaderSection extends ConsumerStatefulWidget {
  const ReceiptHeaderSection({super.key, this.branchId});

  final String? branchId;

  @override
  ConsumerState<ReceiptHeaderSection> createState() =>
      _ReceiptHeaderSectionState();
}

class _ReceiptHeaderSectionState extends ConsumerState<ReceiptHeaderSection> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  BranchDocumentSettings? _settings;
  bool _loading = true;
  bool _saving = false;
  bool _missingContact = false;
  String? _status;
  bool _statusIsError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _phone.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final services = ref.read(branchServicesProvider);
    final store = ref.read(receiptHeaderStoreProvider);
    final branchId = widget.branchId ?? services.box.getBranchId();
    if (branchId == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final settings = await store.load(branchId);
    String? businessPhone;
    String? businessEmail;
    try {
      final business = await services.strategy.getBusiness(
        businessId: services.box.getBusinessId(),
      );
      businessPhone = business?.phoneNumber;
      businessEmail = business?.email;
    } catch (_) {
      // No business details to start from; the cashier types them in.
    }
    if (!mounted) return;

    final phone = settings.receiptPhoneOr(businessPhone);
    final email = settings.receiptEmailOr(businessEmail);
    setState(() {
      _settings = settings;
      _phone.text = phone;
      _email.text = email;
      _message.text = settings.receiptMessage ?? '';
      _missingContact = phone.isEmpty || email.isEmpty;
      _loading = false;
    });
  }

  Future<void> _save() async {
    final settings = _settings;
    if (settings == null || !_formKey.currentState!.validate()) return;
    final l10n = context.flipperL10n;
    setState(() {
      _saving = true;
      _status = null;
    });

    final next = settings.copyWith(
      receiptPhone: _phone.text.trim(),
      receiptEmail: _email.text.trim(),
      receiptMessage: _message.text.trim(),
    );
    final ok = await ref.read(receiptHeaderStoreProvider).save(next);
    if (!mounted) return;
    setState(() {
      _saving = false;
      if (ok) {
        _settings = next;
        _missingContact = false;
      }
      _status = ok ? l10n.receiptHeaderSaved : l10n.receiptHeaderSaveError;
      _statusIsError = !ok;
    });
  }

  String? _required(String? value, bool Function(String) valid, String bad) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return context.flipperL10n.taxSettingsRequired;
    return valid(text) ? null : bad;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;

    final phone = ConfigTextField(
      fieldKey: const ValueKey('receiptHeaderPhone'),
      controller: _phone,
      label: l10n.receiptHeaderPhone,
      prefixIcon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      validator: (v) =>
          _required(v, isValidReceiptPhone, l10n.receiptHeaderPhoneInvalid),
    );
    final email = ConfigTextField(
      fieldKey: const ValueKey('receiptHeaderEmail'),
      controller: _email,
      label: l10n.receiptHeaderEmail,
      prefixIcon: Icons.mail_outline,
      keyboardType: TextInputType.emailAddress,
      validator: (v) =>
          _required(v, isValidReceiptEmail, l10n.receiptHeaderEmailInvalid),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConfigSectionLabel(title: l10n.receiptHeaderTitle),
        const SizedBox(height: 6),
        ConfigSectionHint(l10n.receiptHeaderSubtitle),
        const SizedBox(height: 14),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: SystemConfigTokens.accent,
                ),
              ),
            ),
          )
        else
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_missingContact) ...[
                  ConfigNotice(
                    key: const ValueKey('receiptHeaderMissing'),
                    tone: ConfigNoticeTone.warning,
                    message: l10n.receiptHeaderMissing,
                  ),
                  const SizedBox(height: 14),
                ],
                // Side by side in a dialog, stacked on a phone. Not a
                // LayoutBuilder: DevicePreview already wraps the app in one.
                if (MediaQuery.sizeOf(context).width < 640)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [phone, const SizedBox(height: 14), email],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: phone),
                      const SizedBox(width: 14),
                      Expanded(child: email),
                    ],
                  ),
                const SizedBox(height: 14),
                ConfigTextField(
                  fieldKey: const ValueKey('receiptHeaderMessage'),
                  controller: _message,
                  label: l10n.receiptHeaderMessage,
                  prefixIcon: Icons.waving_hand_outlined,
                  hintText: BranchDocumentSettings.defaultReceiptMessage,
                  maxLength: BranchDocumentSettings.maxReceiptMessageLength,
                  helper: l10n.receiptHeaderMessageHelp,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _status == null
                          ? const SizedBox.shrink()
                          : ConfigNotice(
                              key: const ValueKey('receiptHeaderStatus'),
                              tone: _statusIsError
                                  ? ConfigNoticeTone.error
                                  : ConfigNoticeTone.success,
                              message: _status!,
                            ),
                    ),
                    const SizedBox(width: 12),
                    ConfigActionButton(
                      key: const ValueKey('receiptHeaderSave'),
                      label: l10n.receiptHeaderSave,
                      icon: Icons.save_outlined,
                      busy: _saving,
                      onPressed: _save,
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
