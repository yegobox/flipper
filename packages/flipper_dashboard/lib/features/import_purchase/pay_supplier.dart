import 'package:flipper_accounting/bill_payments.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_helpers.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_tokens.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_ui.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/services/purchase_approval_deps.dart';
import 'package:flipper_models/services/purchase_supplier_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/all_models.dart' as model;

typedef _T = ImportPurchaseTokens;

final _money = NumberFormat('#,##0.##');

/// An approved purchase's bill, for the "Pay supplier" action.
final purchaseBillProvider = FutureProvider.autoDispose
    .family<PurchaseBill?, String>(
      (ref, purchaseId) => PurchaseSupplierPayment.billFor(purchaseId),
    );

/// What is still owed to the supplier of an approved purchase, with the
/// button that pays it. Nothing for purchases without a bill (RRA) or with
/// nothing owed.
class PaySupplierBar extends ConsumerWidget {
  const PaySupplierBar({
    super.key,
    required this.purchase,
    required this.currency,
    this.padding = EdgeInsets.zero,
    this.compact = false,
  });

  final model.Purchase purchase;
  final String currency;

  /// Around the bar only when it shows.
  final EdgeInsets padding;

  /// Sized to its content, for a row of other actions.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      _bar(context, ref) ?? const SizedBox.shrink();

  Widget? _bar(BuildContext context, WidgetRef ref) {
    final content = _content(context, ref);
    return content == null ? null : Padding(padding: padding, child: content);
  }

  Widget? _content(BuildContext context, WidgetRef ref) {
    final bill = ref.watch(purchaseBillProvider(purchase.id)).value;
    if (bill == null) return null;
    final l10n = context.flipperL10n;
    if (bill.balance.isSettled) {
      // Only worth saying for purchases that were bought on credit.
      if (purchase.pmtTyCd != '02' && purchase.pmtTyCd != '03') return null;
      return Text(
        l10n.purchasePaidInFull,
        style: ImportPurchaseHelpers.text(
          size: 14,
          weight: FontWeight.w600,
          color: _T.greenStrong,
        ),
      );
    }
    final owed = Text(
      l10n.purchaseOwedToSupplier(
        '$currency ${_money.format(bill.balance.balance)}',
      ),
      style: ImportPurchaseHelpers.text(
        size: compact ? 13 : 14,
        weight: FontWeight.w600,
        color: _T.amber,
      ),
    );
    return Row(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        if (compact) owed else Expanded(child: owed),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: () => showPaySupplierDialog(
            context,
            ref,
            purchase: purchase,
            bill: bill,
            currency: currency,
          ),
          icon: const Icon(Icons.payments_outlined, size: 18),
          label: Text(l10n.purchasePaySupplier),
          style: FilledButton.styleFrom(
            backgroundColor: _T.accent,
            minimumSize: Size(0, compact ? 36 : 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_T.radiusSm),
            ),
          ),
        ),
      ],
    );
  }
}

/// Asks how much was paid and from where, records it, then refreshes what
/// is owed.
Future<void> showPaySupplierDialog(
  BuildContext context,
  WidgetRef ref, {
  required model.Purchase purchase,
  required PurchaseBill bill,
  required String currency,
}) async {
  final after = await showDialog<BillBalance>(
    context: context,
    builder: (_) =>
        _PaySupplierDialog(purchase: purchase, bill: bill, currency: currency),
  );
  if (after == null) return;
  ref.invalidate(purchaseBillProvider(purchase.id));
  if (!context.mounted) return;
  final l10n = context.flipperL10n;
  showImportPurchaseToast(
    context,
    after.isSettled
        ? l10n.purchaseSupplierPaidInFull
        : l10n.purchaseSupplierPaid(
            '$currency ${_money.format(after.balance)}',
          ),
  );
}

class _PaySupplierDialog extends StatefulWidget {
  const _PaySupplierDialog({
    required this.purchase,
    required this.bill,
    required this.currency,
  });

  final model.Purchase purchase;
  final PurchaseBill bill;
  final String currency;

  @override
  State<_PaySupplierDialog> createState() => _PaySupplierDialogState();
}

class _PaySupplierDialogState extends State<_PaySupplierDialog> {
  late final TextEditingController _amount = TextEditingController(
    text: '${widget.bill.balance.balance}',
  );
  String _from = supplierPaidFromCash;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    final l10n = context.flipperL10n;
    final owed = widget.bill.balance.balance;
    final amount = int.tryParse(_amount.text.trim()) ?? 0;
    if (amount <= 0 || amount > owed) {
      setState(
        () => _error = l10n.purchasePayAmountTooHigh(
          '${widget.currency} ${_money.format(owed)}',
        ),
      );
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final after = await PurchaseSupplierPayment.pay(
        purchase: widget.purchase,
        bill: widget.bill,
        amount: amount,
        accountCode: _from,
        deps: PurchaseApprovalDeps.fromProxy(),
      );
      if (mounted) Navigator.of(context).pop(after);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = l10n.purchasePaySupplierFailed('$e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final supplier = widget.purchase.spplrNm.trim();
    return AlertDialog(
      title: Text(
        supplier.isEmpty
            ? l10n.purchasePaySupplier
            : '${l10n.purchasePaySupplier} · $supplier',
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.purchaseOwedToSupplier(
                '${widget.currency} '
                '${_money.format(widget.bill.balance.balance)}',
              ),
              style: ImportPurchaseHelpers.text(
                size: 13,
                weight: FontWeight.w500,
                color: _T.muted,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _amount,
              enabled: !_saving,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.amount,
                prefixText: '${widget.currency} ',
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _pay(),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.purchasePaidFrom,
              style: ImportPurchaseHelpers.text(
                size: 13,
                weight: FontWeight.w600,
                color: _T.ink2,
              ),
            ),
            const SizedBox(height: 6),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: supplierPaidFromCash,
                  label: Text(l10n.cash),
                ),
                ButtonSegment(
                  value: supplierPaidFromBank,
                  label: Text(l10n.purchasePaidFromBank),
                ),
                ButtonSegment(
                  value: supplierPaidFromMomo,
                  label: Text(l10n.purchasePaidFromMomo),
                ),
              ],
              selected: {_from},
              onSelectionChanged: _saving
                  ? null
                  : (v) => setState(() => _from = v.first),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: ImportPurchaseHelpers.text(
                  size: 13,
                  weight: FontWeight.w500,
                  color: _T.redStrong,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _pay,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.purchasePaySupplier),
        ),
      ],
    );
  }
}
