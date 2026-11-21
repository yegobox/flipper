import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
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

/// Tax Settings → Receipt header: the phone, email and welcome line printed
/// at the top of every receipt from [branchId].
///
/// Phone and email are required, so a saved header can never print a bare
/// `TEL:` or `EMAIL:`. They start from the business's own details when the
/// branch has not set any.
class ReceiptHeaderSection extends ConsumerStatefulWidget {
  const ReceiptHeaderSection({super.key, required this.branchId});

  final String branchId;

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

    final settings = await store.load(widget.branchId);
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final theme = Theme.of(context);

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.receiptHeaderTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(l10n.receiptHeaderSubtitle, style: theme.textTheme.bodySmall),
          if (_missingContact) ...[
            const SizedBox(height: 12),
            Container(
              key: const ValueKey('receiptHeaderMissing'),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade800,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.receiptHeaderMissing,
                      style: TextStyle(color: Colors.orange.shade900),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextFormField(
            key: const ValueKey('receiptHeaderPhone'),
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: l10n.receiptHeaderPhone,
              prefixIcon: const Icon(Icons.phone_outlined),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return l10n.taxSettingsRequired;
              if (!isValidReceiptPhone(text)) {
                return l10n.receiptHeaderPhoneInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const ValueKey('receiptHeaderEmail'),
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.receiptHeaderEmail,
              prefixIcon: const Icon(Icons.email_outlined),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return l10n.taxSettingsRequired;
              if (!isValidReceiptEmail(text)) {
                return l10n.receiptHeaderEmailInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const ValueKey('receiptHeaderMessage'),
            controller: _message,
            maxLength: BranchDocumentSettings.maxReceiptMessageLength,
            decoration: InputDecoration(
              labelText: l10n.receiptHeaderMessage,
              hintText: BranchDocumentSettings.defaultReceiptMessage,
              helperText: l10n.receiptHeaderMessageHelp,
              helperMaxLines: 2,
              prefixIcon: const Icon(Icons.waving_hand_outlined),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
          if (_status != null) ...[
            const SizedBox(height: 8),
            Text(
              _status!,
              key: const ValueKey('receiptHeaderStatus'),
              style: TextStyle(
                color: _statusIsError
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              key: const ValueKey('receiptHeaderSave'),
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(l10n.receiptHeaderSave),
            ),
          ),
        ],
      ),
    );
  }
}
