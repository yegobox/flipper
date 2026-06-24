import 'dart:async';

import 'package:flipper_dashboard/RefundReasonForm.dart';
import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_dashboard/services/transaction_refund_helpers.dart';
import 'package:flipper_dashboard/services/transaction_refund_service.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_dashboard/widgets/transaction_detail_svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract final class _PreviewColors {
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF8F9FC);
  static const line = Color(0xFFE8ECF4);
  static const ink1 = Color(0xFF111827);
  static const ink2 = Color(0xFF374151);
  static const ink3 = Color(0xFF6B7280);
  static const ink4 = Color(0xFF9CA3AF);
  static const gain = Color(0xFF16A34A);
  static const gainInk = Color(0xFF15803D);
  static const gainTint = Color(0xFFE7F6EE);
  static const loss = Color(0xFFE5484D);
  static const lossInk = Color(0xFFB42318);
  static const lossTint = Color(0xFFFEECEC);
  static const pendingTint = Color(0xFFFCEFD6);
  static const pendingInk = Color(0xFFB7791F);
  static const pendingDot = Color(0xFFD97706);
  static const blueTint = Color(0xFFEFF6FF);
  static const blue = Color(0xFF2563EB);
}

class _PreviewStatus {
  const _PreviewStatus({
    required this.label,
    required this.background,
    required this.foreground,
    required this.dot,
  });

  final String label;
  final Color background;
  final Color foreground;
  final Color dot;
}

class Refund extends StatefulHookConsumerWidget {
  const Refund({
    super.key,
    required this.refundAmount,
    required this.transactionId,
    required this.currency,
    this.transaction,
  });

  final double refundAmount;
  final String transactionId;
  final String? currency;
  final ITransaction? transaction;

  @override
  ConsumerState<Refund> createState() => _RefundState();
}

class _RefundState extends ConsumerState<Refund> {
  bool isRefundProcessing = false;
  bool isPrintingCopy = false;
  bool _refundBlocked = false;
  final talker = TalkerFlutter.init();
  late final _refundService = TransactionRefundService(talker: talker);

  ITransaction? get _transaction => widget.transaction;

  bool get _alreadyRefunded =>
      _refundBlocked ||
      (_transaction != null && isTransactionRefunded(_transaction!));

  String get _currency =>
      widget.currency ?? ProxyService.box.defaultCurrency();

  @override
  Widget build(BuildContext context) {
    final tx = _transaction;
    final amountText = NumberFormat('#,##0.00').format(widget.refundAmount);
    final taxAmount = tx != null ? TransactionSummaryTax.taxColumn(tx) : 0.0;
    final taxText = NumberFormat('#,##0.00').format(taxAmount);
    final status = _statusFor(tx);
    final subtitle = _subtitleFor(tx);
    final shortId = _shortTransactionId(widget.transactionId);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: SizedBox(
          width: 440,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PreviewHeader(
                status: status,
                onClose: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 20),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: _PreviewColors.ink3,
                ),
              ),
              const SizedBox(height: 16),
              _AmountHero(
                currency: _currency,
                amount: amountText,
              ),
              const SizedBox(height: 16),
              _TransactionIdPill(
                shortId: shortId,
                transactionId: widget.transactionId,
              ),
              const SizedBox(height: 24),
              RefundReasonForm(enabled: !_alreadyRefunded),
              const SizedBox(height: 20),
              _FinancialBreakdown(
                currency: _currency,
                taxAmount: taxText,
                refundAmount: amountText,
              ),
              const SizedBox(height: 24),
              _RefundActionButton(
                label: _alreadyRefunded
                    ? 'Refunded'
                    : 'Refund $_currency $amountText',
                busy: isRefundProcessing,
                enabled: !_alreadyRefunded,
                onTap: () => _onRefundTap(context),
              ),
              const SizedBox(height: 12),
              _PrintCopyButton(
                busy: isPrintingCopy,
                onTap: () => _onPrintCopyTap(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRefundTap(BuildContext context) async {
    if (_alreadyRefunded) return;

    setState(() => isRefundProcessing = true);
    try {
      final tx = _transaction!;
      _refundService.validateCanRefund(tx);

      final needsPurchaseCode =
          tx.customerTin != null && tx.customerTin!.isNotEmpty;
      if (needsPurchaseCode) {
        final ok = await TransactionRefundService.showPurchaseCodeDialog(
          context,
        );
        if (!ok) return;
      }

      if (tx.receiptType == 'TS') {
        await _refundService.executeLegacyFullRefund(
          transaction: tx,
          refundAmount: widget.refundAmount,
          receiptType: 'TR',
        );
      } else if (tx.receiptType == 'PS') {
        toast('Can not refund a proforma');
        return;
      } else if (tx.receiptType == 'NS') {
        await _refundService.executeLegacyFullRefund(
          transaction: tx,
          refundAmount: widget.refundAmount,
          receiptType: 'NR',
        );
      } else if (tx.receiptType == 'CS') {
        await _refundService.executeLegacyFullRefund(
          transaction: tx,
          refundAmount: widget.refundAmount,
          receiptType: 'CR',
        );
      } else {
        toast('This receipt cannot be refunded');
        return;
      }

      if (mounted) setState(() => _refundBlocked = true);
    } catch (e, s) {
      toast(e.toString());
      talker.error(s);
    } finally {
      if (mounted) setState(() => isRefundProcessing = false);
    }
  }

  Future<void> _onPrintCopyTap(BuildContext context) async {
    final tx = _transaction!;
    if (tx.receiptType == 'TS') {
      toast('This receipt does not have a copy to print');
      return;
    }

    final needsPurchaseCode =
        tx.customerTin != null && tx.customerTin!.isNotEmpty;
    if (needsPurchaseCode) {
      final ok = await TransactionRefundService.showPurchaseCodeDialog(context);
      if (!ok) return;
    }

    setState(() => isPrintingCopy = true);
    try {
      if (tx.receiptType == 'PS') {
        await _refundService.handleReceiptCopy(
          transaction: tx,
          filterType: isTransactionRefunded(tx)
              ? FilterType.PR
              : FilterType.CP,
        );
      } else {
        await _refundService.handleReceiptCopy(
          transaction: tx,
          filterType: isTransactionRefunded(tx)
              ? FilterType.CR
              : FilterType.CS,
        );
      }
    } catch (e, s) {
      toast(e.toString());
      talker.error(s);
    } finally {
      if (mounted) setState(() => isPrintingCopy = false);
    }
  }
}

class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({
    required this.status,
    required this.onClose,
  });

  final _PreviewStatus status;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Transaction',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
            color: _PreviewColors.ink1,
          ),
        ),
        const SizedBox(width: 10),
        _StatusBadge(status: status),
        const Spacer(),
        _IconCircleButton(
          onPressed: onClose,
          child: TransactionDetailSvgs.icon(
            TransactionDetailSvgs.closeX(),
            size: 18,
            color: _PreviewColors.ink2,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final _PreviewStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.only(left: 10, right: 12),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: status.dot,
              boxShadow: [
                BoxShadow(
                  color: status.dot.withValues(alpha: 0.18),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Text(
            status.label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: status.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _PreviewColors.surface2,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(width: 34, height: 34, child: Center(child: child)),
      ),
    );
  }
}

class _AmountHero extends StatelessWidget {
  const _AmountHero({
    required this.currency,
    required this.amount,
  });

  final String currency;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            currency,
            style: FlipperFonts.mono(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _PreviewColors.ink3,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amount,
            style: FlipperFonts.mono(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.03,
              color: _PreviewColors.ink1,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionIdPill extends StatefulWidget {
  const _TransactionIdPill({
    required this.shortId,
    required this.transactionId,
  });

  final String shortId;
  final String transactionId;

  @override
  State<_TransactionIdPill> createState() => _TransactionIdPillState();
}

class _TransactionIdPillState extends State<_TransactionIdPill> {
  bool _copied = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.transactionId));
    if (!mounted) return;
    setState(() => _copied = true);
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: _copied ? _PreviewColors.gainTint : _PreviewColors.surface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: _copied ? _PreviewColors.gain.withValues(alpha: 0.45) : _PreviewColors.line,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: _copy,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: Text(
                    _copied ? 'Copied' : 'Transaction ID',
                    key: ValueKey(_copied),
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _copied ? _PreviewColors.gainInk : _PreviewColors.ink3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.shortId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FlipperFonts.mono(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _copied ? _PreviewColors.gainInk : _PreviewColors.ink2,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    _copied ? Icons.check_rounded : Icons.copy_rounded,
                    key: ValueKey(_copied),
                    size: 18,
                    color: _copied ? _PreviewColors.gain : _PreviewColors.ink3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FinancialBreakdown extends StatelessWidget {
  const _FinancialBreakdown({
    required this.currency,
    required this.taxAmount,
    required this.refundAmount,
  });

  final String currency;
  final String taxAmount;
  final String refundAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _PreviewColors.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _PreviewColors.line),
      ),
      child: Column(
        children: [
          _BreakdownRow(
            label: 'Tax included',
            value: '$currency $taxAmount',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: _DashedDivider(),
          ),
          _BreakdownRow(
            label: 'Refund amount',
            value: '$currency $refundAmount',
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: emphasize ? 15 : 13.5,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
            color: emphasize ? _PreviewColors.ink1 : _PreviewColors.ink2,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: FlipperFonts.mono(
            fontSize: emphasize ? 16 : 14,
            fontWeight: FontWeight.w700,
            color: emphasize ? _PreviewColors.loss : _PreviewColors.ink1,
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 5.0;
        const dashSpace = 4.0;
        final dashCount =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: 1,
              color: _PreviewColors.line,
            );
          }),
        );
      },
    );
  }
}

class _RefundActionButton extends StatelessWidget {
  const _RefundActionButton({
    required this.label,
    required this.busy,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool busy;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = enabled && !busy;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: active ? onTap : null,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: active
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFEF5350), Color(0xFFD93A3F)],
                  )
                : null,
            color: active ? null : _PreviewColors.ink4.withValues(alpha: 0.35),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: const Color(0xFFD93A3F).withValues(alpha: 0.45),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                      spreadRadius: -8,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TransactionDetailSvgs.icon(
                        TransactionDetailSvgs.refresh(),
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 9),
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _PrintCopyButton extends StatelessWidget {
  const _PrintCopyButton({
    required this.busy,
    required this.onTap,
  });

  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _PreviewColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: _PreviewColors.line, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: busy ? null : onTap,
        child: SizedBox(
          height: 52,
          child: Center(
            child: busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TransactionDetailSvgs.icon(
                        TransactionDetailSvgs.print(),
                        size: 18,
                        color: _PreviewColors.ink2,
                      ),
                      const SizedBox(width: 9),
                      Text(
                        'Print copy receipt',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _PreviewColors.ink2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

_PreviewStatus _statusFor(ITransaction? tx) {
  if (tx == null) {
    return const _PreviewStatus(
      label: 'COMPLETED',
      background: _PreviewColors.gainTint,
      foreground: _PreviewColors.gainInk,
      dot: _PreviewColors.gain,
    );
  }

  if (isTransactionRefunded(tx)) {
    final normalized = (tx.status ?? '').toLowerCase();
    if (normalized == 'partially_refunded') {
      return const _PreviewStatus(
        label: 'PARTIALLY REFUNDED',
        background: _PreviewColors.pendingTint,
        foreground: _PreviewColors.pendingInk,
        dot: _PreviewColors.pendingDot,
      );
    }
    return const _PreviewStatus(
      label: 'REFUNDED',
      background: _PreviewColors.lossTint,
      foreground: _PreviewColors.lossInk,
      dot: _PreviewColors.loss,
    );
  }

  final normalized = (tx.status ?? 'unknown').toLowerCase();
  switch (normalized) {
    case 'pending':
    case 'waiting':
    case 'waitingmomocomplete':
      return const _PreviewStatus(
        label: 'PENDING',
        background: _PreviewColors.pendingTint,
        foreground: _PreviewColors.pendingInk,
        dot: _PreviewColors.pendingDot,
      );
    case 'completed':
    case 'complete':
      return const _PreviewStatus(
        label: 'COMPLETED',
        background: _PreviewColors.gainTint,
        foreground: _PreviewColors.gainInk,
        dot: _PreviewColors.gain,
      );
    case 'parked':
      return const _PreviewStatus(
        label: 'PARKED',
        background: _PreviewColors.blueTint,
        foreground: _PreviewColors.blue,
        dot: _PreviewColors.blue,
      );
    default:
      return _PreviewStatus(
        label: (tx.status ?? 'UNKNOWN').toUpperCase(),
        background: _PreviewColors.surface2,
        foreground: _PreviewColors.ink2,
        dot: _PreviewColors.ink3,
      );
  }
}

String _subtitleFor(ITransaction? tx) {
  final payment = _paymentLabel(tx?.paymentType).toUpperCase();
  final instant = tx?.lastTouched ?? tx?.updatedAt ?? tx?.createdAt;
  final datePart = instant != null
      ? DateFormat('MMM dd, yyyy').format(instant).toUpperCase()
      : '—';
  return '$payment SALE · $datePart';
}

String _paymentLabel(String? paymentType) {
  if (paymentType == null || paymentType.trim().isEmpty) return 'Cash';
  final upper = paymentType.toUpperCase();
  if (upper.contains('MOMO') || upper.contains('MOBILE')) return 'MoMo';
  if (upper.contains('CARD')) return 'Card';
  if (upper.contains('CASH')) return 'Cash';
  return paymentType;
}

String _shortTransactionId(String id) {
  if (id.length <= 20) return id;
  return '${id.substring(0, 13)}...';
}
