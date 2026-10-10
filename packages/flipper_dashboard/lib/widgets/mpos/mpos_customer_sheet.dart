import 'package:flipper_localize/flipper_localize.dart';

import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'package:flipper_dashboard/providers/mpos_customer_actions_provider.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_customer_match.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_animated_sheet.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_section_label.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Customer sheet for mobile checkout ([design_handoff_mobile_pos] CustomerSheet).
///
/// Two taps at most: open the sheet, then tap a recent/matching customer or
/// the add button. A new customer needs only a phone; the name is optional.
class MposCustomerSheet {
  static Future<void> show({
    required BuildContext context,
    required WidgetRef ref,
    required ITransaction transaction,
    VoidCallback? onAttached,
  }) {
    return showMposAnimatedSheet<void>(
      context: context,
      builder: (ctx) => MposCustomerSheetBody(
        transaction: transaction,
        onAttached: onAttached,
      ),
    );
  }
}

@visibleForTesting
class MposCustomerSheetBody extends ConsumerStatefulWidget {
  const MposCustomerSheetBody({
    super.key,
    required this.transaction,
    this.onAttached,
  });

  final ITransaction transaction;
  final VoidCallback? onAttached;

  @override
  ConsumerState<MposCustomerSheetBody> createState() =>
      _MposCustomerSheetBodyState();
}

class _MposCustomerSheetBodyState extends ConsumerState<MposCustomerSheetBody> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  Future<void> _attach(Customer customer) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(mposCustomerActionsProvider)
          .attach(customer, widget.transaction);
      _done(customer);
    } catch (e) {
      _fail(e);
    }
  }

  Future<void> _submit(List<Customer> all) async {
    if (_saving) return;
    final phone = _phoneController.text;
    final existing = mposExactPhoneMatch(all, phone);
    if (existing != null) return _attach(existing);
    if (mposPhoneDigits(phone).length < mposMinCustomerPhoneDigits) return;

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final saved = await ref
          .read(mposCustomerActionsProvider)
          .quickAdd(
            phone: phone,
            name: _nameController.text,
            transaction: widget.transaction,
          );
      _done(saved);
    } catch (e) {
      _fail(e);
    }
  }

  /// The customer card switching over is the confirmation — no toast.
  void _done(Customer customer) {
    if (!mounted) return;
    HapticFeedback.selectionClick();
    ref.read(customerPhoneNumberProvider.notifier).state = customer.telNo;
    ref.invalidate(attachedCustomerProvider(customer.id));
    ref.invalidate(transactionByIdProvider(widget.transaction.id));
    ref.invalidate(pendingTransactionStreamProvider(isExpense: false));
    Navigator.of(context).pop();
    widget.onAttached?.call();
  }

  void _fail(Object e) {
    talker.warning('MposCustomerSheet: $e');
    if (!mounted) return;
    setState(() {
      _saving = false;
      _error = context.flipperL10n.mposCouldNotAttachCustomer(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final media = MediaQuery.of(context);
    final maxH = (media.size.height * 0.88).clamp(
      0.0,
      media.size.height - media.padding.top - media.viewInsets.bottom - 16,
    );

    final all =
        ref.watch(customersProvider).asData?.value ?? const <Customer>[];
    final phone = _phoneController.text;
    final name = _nameController.text;
    final typing = phone.trim().isNotEmpty || name.trim().isNotEmpty;
    final matches = mposCustomerMatches(all, phone: phone, name: name);
    final existing = mposExactPhoneMatch(all, phone);
    final phoneComplete =
        mposPhoneDigits(phone).length >= mposMinCustomerPhoneDigits;

    final String buttonLabel;
    if (existing != null) {
      buttonLabel = l10n.mposUseExistingCustomer(
        existing.custNm ?? existing.telNo ?? '',
      );
    } else if (phoneComplete) {
      buttonLabel = l10n.mposAddCustomerWithPhone(phone.trim());
    } else {
      buttonLabel = l10n.mposEnterCustomerPhone;
    }

    return Material(
      color: PosTokens.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(MposTokens.sheetRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: PosTokens.lineStrong,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.addCustomer,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: PosTokens.ink1,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    style: IconButton.styleFrom(
                      backgroundColor: PosTokens.surface2,
                    ),
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: PosTokens.surface2,
                  borderRadius: BorderRadius.circular(MposTokens.radiusMd),
                  border: Border.all(color: PosTokens.line, width: 1.5),
                ),
                child: Column(
                  children: [
                    _FieldRow(
                      key: const ValueKey('mposCustomerPhoneField'),
                      icon: Icons.phone_outlined,
                      controller: _phoneController,
                      hint: l10n.mposCustomerPhoneHint,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                      ],
                      onChanged: (_) => setState(() => _error = null),
                      onSubmitted: (_) => _nameFocus.requestFocus(),
                    ),
                    const Divider(height: 1, color: PosTokens.line),
                    _FieldRow(
                      key: const ValueKey('mposCustomerNameField'),
                      icon: Icons.person_outline_rounded,
                      controller: _nameController,
                      focusNode: _nameFocus,
                      hint: l10n.mposCustomerNameOptionalHint,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => setState(() => _error = null),
                      onSubmitted: (_) => _submit(all),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
                children: [
                  if (matches.isNotEmpty) ...[
                    MposSectionLabel(
                      typing
                          ? l10n.mposMatchingCustomers
                          : l10n.mposRecentCustomers,
                    ),
                    const SizedBox(height: 4),
                    for (final c in matches)
                      _CustomerRow(
                        customer: c,
                        fallbackName: l10n.customer,
                        onTap: _saving ? null : () => _attach(c),
                      ),
                  ] else if (typing)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        l10n.mposNoCustomerMatches,
                        style: const TextStyle(
                          fontSize: 13,
                          color: PosTokens.ink3,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_error != null) ...[
                    Text(
                      _error!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: PosTokens.lossInk,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  _SubmitButton(
                    label: buttonLabel,
                    icon: existing != null
                        ? Icons.person_rounded
                        : Icons.add_rounded,
                    loading: _saving,
                    onPressed: existing != null || phoneComplete
                        ? () => _submit(all)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    super.key,
    required this.icon,
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });

  final IconData icon;
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: PosTokens.ink3),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: autofocus,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                textCapitalization: textCapitalization,
                inputFormatters: inputFormatters,
                style: const TextStyle(fontSize: 15.5, color: PosTokens.ink1),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: PosTokens.ink4),
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: onChanged,
                onSubmitted: onSubmitted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerRow extends StatelessWidget {
  const _CustomerRow({
    required this.customer,
    required this.fallbackName,
    required this.onTap,
  });

  final Customer customer;
  final String fallbackName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final name = customer.custNm ?? customer.telNo ?? fallbackName;
    final phone = customer.telNo;
    final color = mposColorForName(name);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(MposTokens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                mposAbbreviation(name),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      color: PosTokens.ink1,
                    ),
                  ),
                  if (phone != null && phone.isNotEmpty && phone != name)
                    Text(
                      phone,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: PosTokens.ink3,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: PosTokens.ink4),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.label,
    required this.icon,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(15),
          child: Ink(
            height: MposTokens.checkoutPrimaryHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: enabled || loading ? MposTokens.gradBtn : null,
              color: enabled || loading
                  ? null
                  : PosTokens.ink4.withValues(alpha: 0.35),
              boxShadow: enabled ? MposTokens.shadowBlue : null,
            ),
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 19, color: Colors.white),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
