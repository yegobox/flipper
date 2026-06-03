import 'package:flipper_dashboard/services/transaction_refund_service.dart';
import 'package:flipper_dashboard/widgets/transaction_detail_svgs.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

// Handoff tokens aligned with transactions_details.dart
abstract final class _SheetColors {
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF8F9FC);
  static const line = Color(0xFFE8ECF4);
  static const ink1 = Color(0xFF111827);
  static const ink2 = Color(0xFF374151);
  static const ink3 = Color(0xFF6B7280);
  static const ink4 = Color(0xFF9CA3AF);
  static const loss = Color(0xFFE5484D);
  static const lossInk = Color(0xFFB42318);
  static const gain = Color(0xFF16A34A);
  static const blue = Color(0xFF2563EB);
}

const _refundReasons = [
  'Customer request',
  'Wrong item',
  'Damaged / faulty',
  'Duplicate charge',
  'Other',
];

/// Opens the More Actions bottom sheet.
Future<void> showTransactionActionsSheet({
  required BuildContext context,
  required ITransaction transaction,
  required String referenceLabel,
  required VoidCallback onRefund,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _TransactionActionsSheet(
      transaction: transaction,
      referenceLabel: referenceLabel,
      onRefund: () {
        Navigator.of(ctx).pop();
        onRefund();
      },
    ),
  );
}

/// Opens the guided refund flow; returns updated transaction on success.
Future<ITransaction?> showTransactionRefundSheet({
  required BuildContext context,
  required ITransaction transaction,
  required String referenceLabel,
}) {
  return showModalBottomSheet<ITransaction?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    enableDrag: false,
    builder: (ctx) => _TransactionRefundSheet(
      transaction: transaction,
      referenceLabel: referenceLabel,
    ),
  );
}

class _TransactionActionsSheet extends StatelessWidget {
  const _TransactionActionsSheet({
    required this.transaction,
    required this.referenceLabel,
    required this.onRefund,
  });

  final ITransaction transaction;
  final String referenceLabel;
  final VoidCallback onRefund;

  @override
  Widget build(BuildContext context) {
    final refunded = transaction.isRefunded == true;
    return _SheetScaffold(
      fillHeight: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(child: _SheetHandle()),
          _SheetHeader(
            title: 'More actions',
            subtitle: 'Income · $referenceLabel',
            onClose: () => Navigator.of(context).pop(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Column(
              children: [
                _ActionRow(
                  iconSvg: TransactionDetailSvgs.share(),
                  title: 'Share receipt',
                  subtitle: 'Send via WhatsApp, SMS or email',
                  onTap: () {
                    Navigator.of(context).pop();
                    _stubAction(context, 'Share is not available yet.');
                  },
                ),
                _ActionRow(
                  iconSvg: TransactionDetailSvgs.download(),
                  title: 'Download PDF',
                  subtitle: 'Save a copy of this receipt',
                  onTap: () {
                    Navigator.of(context).pop();
                    _stubAction(context, 'Download is not available yet.');
                  },
                ),
                _ActionRow(
                  iconSvg: TransactionDetailSvgs.print(),
                  title: 'Print receipt',
                  subtitle: 'Send to a connected printer',
                  onTap: () {
                    Navigator.of(context).pop();
                    _stubAction(context, 'Print is not available yet.');
                  },
                ),
                _ActionRow(
                  iconSvg: TransactionDetailSvgs.refresh(),
                  title: refunded ? 'Already refunded' : 'Refund payment',
                  subtitle: refunded
                      ? 'This income has been refunded'
                      : 'Return money to the customer',
                  danger: true,
                  showChevron: !refunded,
                  enabled: !refunded,
                  onTap: refunded ? null : onRefund,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _stubAction(BuildContext context, String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}

enum _RefundStep { form, processing, done }

class _TransactionRefundSheet extends ConsumerStatefulWidget {
  const _TransactionRefundSheet({
    required this.transaction,
    required this.referenceLabel,
  });

  final ITransaction transaction;
  final String referenceLabel;

  @override
  ConsumerState<_TransactionRefundSheet> createState() =>
      _TransactionRefundSheetState();
}

class _TransactionRefundSheetState
    extends ConsumerState<_TransactionRefundSheet> {
  _RefundStep _step = _RefundStep.form;
  bool _fullRefund = true;
  String _amountText = '';
  String _reason = _refundReasons.first;
  String _method = 'cash';
  double? _completedAmount;
  bool _completedPartial = false;
  ITransaction? _completedTransaction;
  final _service = TransactionRefundService();
  late final TextEditingController _partialAmountController;

  double get _total => widget.transaction.subTotal ?? 0;

  double get _refundAmount {
    if (_fullRefund) return _total;
    final parsed = double.tryParse(_amountText.replaceAll(RegExp(r'[^\d]'), ''));
    return parsed ?? 0;
  }

  bool get _amountOver => !_fullRefund && _refundAmount > _total + 0.001;

  bool get _canSubmit =>
      _refundAmount > 0 && !_amountOver && _total > 0;

  @override
  void initState() {
    super.initState();
    _amountText = _total.round().toString();
    _partialAmountController = TextEditingController(text: _amountText);
  }

  @override
  void dispose() {
    _partialAmountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() => _step = _RefundStep.processing);

    try {
      final vatEnabled = await ref.read(ebmVatEnabledProvider.future);
      final result = await _service.execute(
        request: TransactionRefundRequest(
          transaction: widget.transaction,
          refundAmount: _refundAmount,
          reason: _reason,
          method: _method,
        ),
        vatEnabled: vatEnabled,
        context: context,
        requestPurchaseCode: () =>
            TransactionRefundService.showPurchaseCodeDialog(context),
      );
      if (!mounted) return;
      setState(() {
        _step = _RefundStep.done;
        _completedAmount = result.refundAmount;
        _completedPartial = result.partial;
        _completedTransaction = result.transaction;
      });
    } catch (e) {
      if (!mounted) return;
      toast(e.toString());
      setState(() => _step = _RefundStep.form);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_step == _RefundStep.processing) {
      return const _RefundProcessingOverlay();
    }
    if (_step == _RefundStep.done) {
      return _RefundDoneOverlay(
        amount: _completedAmount ?? _refundAmount,
        method: _method,
        partial: _completedPartial,
        onDone: () => Navigator.of(context).pop(
          _completedTransaction ??
              widget.transaction.copyWith(
                isRefunded: true,
                refundedAmount: _completedAmount ?? _refundAmount,
                refundReason: _reason,
                refundMethod: _method,
                status: _completedPartial ? 'partially_refunded' : 'refunded',
              ),
        ),
      );
    }

    final currency = ProxyService.box.defaultCurrency();
    final money = NumberFormat('#,###');

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: _SheetScaffold(
        fillHeight: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Center(child: _SheetHandle()),
            _SheetHeader(
              title: 'Refund payment',
              subtitle: 'Return money for ${widget.referenceLabel}',
              onClose: () => Navigator.of(context).pop(),
              showBack: true,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _sectionLabel('1 · How much?'),
                  Row(
                    children: [
                      Expanded(
                        child: _RefundSegment(
                          selected: _fullRefund,
                          title: 'Full refund',
                          detail: '$currency ${money.format(_total.round())}',
                          onTap: () => setState(() {
                            _fullRefund = true;
                            _amountText = _total.round().toString();
                            _partialAmountController.text = _amountText;
                          }),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: _RefundSegment(
                          selected: !_fullRefund,
                          title: 'Partial',
                          detail: 'Choose amount',
                          onTap: () => setState(() => _fullRefund = false),
                        ),
                      ),
                    ],
                  ),
                  if (!_fullRefund) ...[
                    const SizedBox(height: 10),
                    _PartialAmountField(
                      currency: currency,
                      controller: _partialAmountController,
                      onChanged: (v) => setState(() => _amountText = v),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7, left: 2, right: 2),
                      child: Text(
                        _amountOver
                            ? "Can't exceed the original $currency ${money.format(_total.round())}"
                            : 'Up to $currency ${money.format(_total.round())} available to refund',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: _amountOver ? FontWeight.w600 : FontWeight.w500,
                          color: _amountOver ? _SheetColors.loss : _SheetColors.ink3,
                        ),
                      ),
                    ),
                  ],
                  _sectionLabel('2 · Reason'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _refundReasons.map((r) {
                      return _ReasonChip(
                        label: r,
                        selected: _reason == r,
                        onTap: () => setState(() => _reason = r),
                      );
                    }).toList(),
                  ),
                  _sectionLabel('3 · Refund to'),
                  Row(
                    children: [
                      Expanded(
                        child: _RefundSegment(
                          selected: _method == 'cash',
                          title: 'Cash',
                          detail: 'Hand back now',
                          onTap: () => setState(() => _method = 'cash'),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: _RefundSegment(
                          selected: _method == 'momo',
                          title: 'MoMo',
                          detail: 'Send to phone',
                          onTap: () => setState(() => _method = 'momo'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _RefundSummary(
                    currency: currency,
                    original: _total,
                    reason: _reason,
                    refundAmount: _refundAmount,
                  ),
                  const SizedBox(height: 18),
                  _RefundConfirmButton(
                    enabled: _canSubmit,
                    label:
                        'Refund $currency ${money.format(_refundAmount.round())}',
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _SheetScaffold extends StatelessWidget {
  const _SheetScaffold({
    required this.child,
    this.fillHeight = false,
  });

  final Widget child;
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    final body = fillHeight
        ? SizedBox(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 0.9,
            child: child,
          )
        : child;

    return Container(
      decoration: const BoxDecoration(
        color: _SheetColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: SafeArea(
        top: false,
        child: body,
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.title,
    required this.subtitle,
    required this.onClose,
    this.showBack = false,
    this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 10),
      child: Row(
        children: [
          if (showBack)
            _IconCircleButton(
              onPressed: onBack ?? onClose,
              child: TransactionDetailSvgs.icon(
                TransactionDetailSvgs.chevronLeft(),
                size: 18,
                color: _SheetColors.ink1,
              ),
            ),
          if (showBack) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _SheetColors.ink1,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: _SheetColors.ink3,
                  ),
                ),
              ],
            ),
          ),
          _IconCircleButton(
            onPressed: onClose,
            child: TransactionDetailSvgs.icon(
              TransactionDetailSvgs.closeX(),
              size: 18,
              color: _SheetColors.ink2,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({required this.onPressed, required this.child});

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _SheetColors.surface2,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(width: 34, height: 34, child: Center(child: child)),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 10, bottom: 4),
      decoration: BoxDecoration(
        color: _SheetColors.line,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.iconSvg,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
    this.showChevron = true,
    this.enabled = true,
  });

  final String iconSvg;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool danger;
  final bool showChevron;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final icBg = danger ? const Color(0xFFFDECEC) : _SheetColors.surface2;
    final icColor = danger ? _SheetColors.loss : _SheetColors.ink2;
    final icBorder = danger ? const Color(0xFFF8D4D4) : _SheetColors.line;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: icBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: icBorder),
                  ),
                  child: Center(
                    child: TransactionDetailSvgs.icon(
                      iconSvg,
                      size: 20,
                      color: icColor,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: danger ? _SheetColors.lossInk : _SheetColors.ink1,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 12.5,
                          color: _SheetColors.ink3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showChevron)
                  TransactionDetailSvgs.icon(
                    TransactionDetailSvgs.chevronRight(),
                    size: 18,
                    color: _SheetColors.ink4,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _sectionLabel(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(2, 16, 2, 8),
    child: Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.03 * 12,
        color: _SheetColors.ink3,
      ),
    ),
  );
}

class _RefundSegment extends StatelessWidget {
  const _RefundSegment({
    required this.selected,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFFEF4F4) : _SheetColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected ? _SheetColors.loss : _SheetColors.line,
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: selected ? _SheetColors.lossInk : _SheetColors.ink1,
                ),
              ),
              Text(
                detail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  color: _SheetColors.ink3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PartialAmountField extends StatelessWidget {
  const _PartialAmountField({
    required this.currency,
    required this.controller,
    required this.onChanged,
  });

  final String currency;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: _SheetColors.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _SheetColors.line, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: _SheetColors.line)),
            ),
            child: Text(
              currency,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: _SheetColors.ink3,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              controller: controller,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 14),
                hintText: '0',
              ),
              onChanged: (v) => onChanged(v.replaceAll(RegExp(r'\D'), '')),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonChip extends StatelessWidget {
  const _ReasonChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFFEF4F4) : _SheetColors.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? _SheetColors.loss : _SheetColors.line,
          width: 1.5,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: selected ? _SheetColors.lossInk : _SheetColors.ink2,
            ),
          ),
        ),
      ),
    );
  }
}

class _RefundSummary extends StatelessWidget {
  const _RefundSummary({
    required this.currency,
    required this.original,
    required this.reason,
    required this.refundAmount,
  });

  final String currency;
  final double original;
  final String reason;
  final double refundAmount;

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat('#,###');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _SheetColors.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _SheetColors.line),
      ),
      child: Column(
        children: [
          _summaryRow('Original payment', '$currency ${money.format(original.round())}'),
          _summaryRow('Reason', reason, mono: false),
          const Divider(height: 16),
          _summaryRow(
            'Refund amount',
            '$currency ${money.format(refundAmount.round())}',
            big: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String k, String v, {bool mono = true, bool big = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              k,
              style: GoogleFonts.outfit(
                fontSize: big ? 15 : 13,
                fontWeight: big ? FontWeight.w700 : FontWeight.w500,
                color: big ? _SheetColors.ink1 : _SheetColors.ink2,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              v,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: (mono ? GoogleFonts.jetBrainsMono : GoogleFonts.outfit)(
                fontSize: big ? 20 : 14,
                fontWeight: FontWeight.w700,
                color: big ? _SheetColors.loss : _SheetColors.ink1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundConfirmButton extends StatelessWidget {
  const _RefundConfirmButton({
    required this.enabled,
    required this.label,
    required this.onPressed,
  });

  final bool enabled;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: enabled
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFEF5350), Color(0xFFD93A3F)],
                  )
                : null,
            color: enabled ? null : _SheetColors.ink4.withValues(alpha: 0.4),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: const Color(0xFFD93A3F).withValues(alpha: 0.5),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                      spreadRadius: -8,
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TransactionDetailSvgs.icon(
                    TransactionDetailSvgs.refresh(),
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    label,
                    maxLines: 1,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

class _RefundProcessingOverlay extends StatelessWidget {
  const _RefundProcessingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.5,
      decoration: BoxDecoration(
        color: _SheetColors.surface.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: _SheetColors.loss),
          const SizedBox(height: 16),
          Text(
            'Processing refund…',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _SheetColors.ink1,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundDoneOverlay extends StatelessWidget {
  const _RefundDoneOverlay({
    required this.amount,
    required this.method,
    required this.partial,
    required this.onDone,
  });

  final double amount;
  final String method;
  final bool partial;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final currency = ProxyService.box.defaultCurrency();
    final money = NumberFormat('#,###');
    final methodLabel = method == 'momo' ? 'MoMo' : 'cash';

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: _SheetColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _SheetColors.gain.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TransactionDetailSvgs.icon(
                TransactionDetailSvgs.check(),
                size: 48,
                color: _SheetColors.gain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Refund completed',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$currency ${money.format(amount.round())} was refunded to the customer via $methodLabel.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: _SheetColors.ink3,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: onDone,
              style: FilledButton.styleFrom(
                backgroundColor: _SheetColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}
