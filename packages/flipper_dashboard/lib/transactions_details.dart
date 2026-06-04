import 'package:flipper_dashboard/services/transaction_receipt_actions_service.dart';
import 'package:flipper_dashboard/services/transaction_refund_helpers.dart';
import 'package:flipper_dashboard/widgets/transaction_detail_sheets.dart';
import 'package:flipper_dashboard/widgets/transaction_detail_svgs.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

// Income detail handoff tokens (.windsurf/design_handoff_income)
abstract final class _TxDetailColors {
  static const bg = Color(0xFFF4F6FB);
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF8F9FC);
  static const line = Color(0xFFE8ECF4);
  static const lineSoft = Color(0xFFF0F2F7);
  static const ink1 = Color(0xFF111827);
  static const ink2 = Color(0xFF374151);
  static const ink3 = Color(0xFF6B7280);
  static const ink4 = Color(0xFF9CA3AF);
  static const gain = Color(0xFF16A34A);
  static const gainInk = Color(0xFF15803D);
  static const gainTint = Color(0xFFE7F6EE);
  static const gainSoft = Color(0xFFF1FAF5);
  static const loss = Color(0xFFE5484D);
  static const lossInk = Color(0xFFB91C1C);
  static const lossTint = Color(0xFFFEECEC);
  static const lossSoft = Color(0xFFFFF5F5);
  static const blue = Color(0xFF2563EB);
  static const blueTint = Color(0xFFEFF6FF);
  static const pendingTint = Color(0xFFFCEFD6);
  static const pendingInk = Color(0xFFB7791F);
  static const pendingDot = Color(0xFFD97706);
}

const _sectionAnimDuration = Duration(milliseconds: 280);
const _sectionAnimCurve = Curves.easeOutCubic;

const _productSwatchColors = [
  Color(0xFF3B6FE0),
  Color(0xFF5457D6),
  Color(0xFF7A56E8),
  Color(0xFF9A5BC4),
  Color(0xFFC2557E),
  Color(0xFFC76B45),
  Color(0xFFB5893B),
  Color(0xFF5E8C3C),
  Color(0xFF2E9E83),
  Color(0xFF2C8FB0),
];

class TransactionDetail extends StatefulHookConsumerWidget {
  const TransactionDetail({super.key, required this.transaction});

  final ITransaction transaction;

  @override
  ConsumerState<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends ConsumerState<TransactionDetail> {
  late ITransaction _transaction;
  bool _openProducts = true;
  bool _openTimeline = false;

  @override
  void initState() {
    super.initState();
    _transaction = widget.transaction;
  }

  bool get _reduceMotion =>
      MediaQuery.disableAnimationsOf(context);

  String get _referenceLabel => _formatReference(_transaction);

  final _receiptActions = TransactionReceiptActionsService();

  Future<void> _openMoreActions() async {
    await showTransactionActionsSheet(
      context: context,
      transaction: _transaction,
      referenceLabel: _referenceLabel,
      onRefund: _openRefundSheet,
    );
  }

  Future<void> _openRefundSheet() async {
    final updated = await showTransactionRefundSheet(
      context: context,
      transaction: _transaction,
      referenceLabel: _referenceLabel,
    );
    if (updated != null && mounted) {
      setState(() {
        _transaction = updated;
        _openTimeline = true;
      });
    }
  }

  _TxDirection get _direction {
    final income = _transaction.isIncome;
    if (income == true) return _TxDirection.income;
    if (income == false) return _TxDirection.expense;
    final type = _transaction.transactionType?.toString() ?? '';
    if (type == 'Cash Out') return _TxDirection.expense;
    return _TxDirection.income;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) => _loadItems(model),
      builder: (context, model, child) {
        final items = model.completedTransactionItemsList;
        final palette = _paletteFor(_direction);

        return Scaffold(
          backgroundColor: _TxDetailColors.bg,
          body: SafeArea(
            child: Column(
              children: [
                _TxDetailHeader(
                  title: _direction == _TxDirection.expense
                      ? 'Expense'
                      : 'Income',
                  onBack: () => locator<RouterService>().back(),
                  onMore: _openMoreActions,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 8),
                    children: [
                      _TxHeroCard(
                        transaction: _transaction,
                        direction: _direction,
                        palette: palette,
                      ),
                      _TxExpandableSection(
                        iconSvg: TransactionDetailSvgs.cart(),
                        iconTone: _SectionIconTone.blue,
                        title: 'Products',
                        subtitle: _itemCountLabel(items.length),
                        isOpen: _openProducts,
                        reduceMotion: _reduceMotion,
                        onToggle: () =>
                            setState(() => _openProducts = !_openProducts),
                        child: _ProductsSectionBody(items: items),
                      ),
                      _TxExpandableSection(
                        iconSvg: TransactionDetailSvgs.clock(),
                        iconTone: _SectionIconTone.green,
                        title: 'Transaction Timeline',
                        subtitle:
                            '${_buildTimeline(_transaction).length} events',
                        isOpen: _openTimeline,
                        reduceMotion: _reduceMotion,
                        onToggle: () =>
                            setState(() => _openTimeline = !_openTimeline),
                        child: _TimelineSectionBody(
                          events: _buildTimeline(_transaction),
                        ),
                      ),
                    ],
                  ),
                ),
                _TxDetailFooter(
                  onMoreActions: _openMoreActions,
                  onInvoice: () => _receiptActions.viewInvoice(
                    context,
                    _transaction,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadItems(CoreViewModel model) async {
    final activeBranch = await ProxyService.strategy.activeBranch(
      branchId: ProxyService.box.getBranchId()!,
    );
    final items = await ProxyService.getStrategy(Strategy.capella)
        .transactionItems(
          branchId: activeBranch.id,
          transactionId: _transaction.id,
          fetchRemote: true,
        );
    model.completedTransactionItemsList = items;
  }
}

enum _TxDirection { income, expense }

class _TxPalette {
  const _TxPalette({
    required this.primary,
    required this.ink,
    required this.tint,
    required this.soft,
    required this.sign,
    required this.directionLabel,
    required this.heroGradientEnd,
  });

  final Color primary;
  final Color ink;
  final Color tint;
  final Color soft;
  final String sign;
  final String directionLabel;
  final Color heroGradientEnd;
}

_TxPalette _paletteFor(_TxDirection direction) {
  if (direction == _TxDirection.expense) {
    return const _TxPalette(
      primary: _TxDetailColors.loss,
      ink: _TxDetailColors.lossInk,
      tint: _TxDetailColors.lossTint,
      soft: _TxDetailColors.lossSoft,
      sign: '−',
      directionLabel: 'Expense recorded',
      heroGradientEnd: _TxDetailColors.lossSoft,
    );
  }
  return const _TxPalette(
    primary: _TxDetailColors.gain,
    ink: _TxDetailColors.gainInk,
    tint: _TxDetailColors.gainTint,
    soft: _TxDetailColors.gainSoft,
    sign: '+',
    directionLabel: 'Income received',
    heroGradientEnd: _TxDetailColors.gainSoft,
  );
}

class _TxDetailHeader extends StatelessWidget {
  const _TxDetailHeader({
    required this.title,
    required this.onBack,
    required this.onMore,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _PressScaleButton(
              onPressed: onBack,
              child: _HeaderIconButton(
                child: TransactionDetailSvgs.icon(
                  TransactionDetailSvgs.chevronLeft(),
                  size: 20,
                  color: _TxDetailColors.ink1,
                ),
              ),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.01,
                  color: _TxDetailColors.ink1,
                ),
              ),
            ),
            _PressScaleButton(
              onPressed: onMore,
              child: _HeaderIconButton(
                child: TransactionDetailSvgs.icon(
                  TransactionDetailSvgs.more(),
                  size: 20,
                  color: _TxDetailColors.ink1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TxDetailFooter extends StatelessWidget {
  const _TxDetailFooter({
    required this.onMoreActions,
    required this.onInvoice,
  });

  final VoidCallback onMoreActions;
  final VoidCallback onInvoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: _TxDetailColors.surface,
        border: Border(top: BorderSide(color: _TxDetailColors.line)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: _PressScaleButton(
              onPressed: onMoreActions,
              child: _FooterButton(
                ghost: true,
                icon: TransactionDetailSvgs.more(),
                label: 'More Actions',
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            flex: 13,
            child: _PressScaleButton(
              onPressed: onInvoice,
              child: _FooterButton(
                ghost: false,
                icon: TransactionDetailSvgs.receipt(),
                label: 'Invoice',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  const _FooterButton({
    required this.ghost,
    required this.icon,
    required this.label,
  });

  final bool ghost;
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: ghost ? _TxDetailColors.surface2 : null,
          gradient: ghost
              ? null
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                ),
          border: ghost
              ? Border.all(color: _TxDetailColors.line, width: 1.5)
              : null,
          boxShadow: ghost
              ? null
              : [
                  BoxShadow(
                    color: _TxDetailColors.blue.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TransactionDetailSvgs.icon(
              icon,
              size: 18,
              color: ghost ? _TxDetailColors.ink2 : Colors.white,
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: ghost ? _TxDetailColors.ink2 : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _TxDetailColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _TxDetailColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}

class _TxHeroCard extends StatelessWidget {
  const _TxHeroCard({
    required this.transaction,
    required this.direction,
    required this.palette,
  });

  final ITransaction transaction;
  final _TxDirection direction;
  final _TxPalette palette;

  @override
  Widget build(BuildContext context) {
    final instant = _transactionInstant(transaction);
    final currency = ProxyService.box.defaultCurrency();
    final subTotal = transaction.subTotal ?? 0;
    final amount = NumberFormat('#,###').format(subTotal);
    final status = _statusPresentation(
      transaction.status,
      isRefunded: transaction.isRefunded == true,
      refundedAmount: transaction.refundedAmount,
      subTotal: subTotal,
    );
    final refunded = transaction.isRefunded == true;
    final fullRefundStrike = refunded &&
        (transaction.refundedAmount == null ||
            !isPartialRefund(
              transaction.refundedAmount!,
              subTotal,
            ));
    final trendSvg = direction == _TxDirection.expense
        ? TransactionDetailSvgs.trendDown()
        : TransactionDetailSvgs.trendUp();
    final heroPalette = refunded
        ? _TxPalette(
            primary: _TxDetailColors.loss,
            ink: _TxDetailColors.lossInk,
            tint: _TxDetailColors.lossTint,
            soft: _TxDetailColors.lossSoft,
            sign: palette.sign,
            directionLabel: palette.directionLabel,
            heroGradientEnd: const Color(0xFFFEF3F3),
          )
        : palette;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: _TxDetailColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: refunded
                        ? [
                            const Color(0xFFF87171),
                            _TxDetailColors.loss,
                          ]
                        : [
                            heroPalette.primary.withValues(alpha: 0.7),
                            heroPalette.primary,
                          ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -1),
                  radius: 1.3,
                  colors: [heroPalette.heroGradientEnd, _TxDetailColors.surface],
                  stops: const [0, 0.58],
                ),
              ),
              child: Column(
                children: [
                  _StatusPill(status: status),
                  if (!refunded) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: heroPalette.tint,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                            child: TransactionDetailSvgs.icon(
                              trendSvg,
                              size: 14,
                              color: heroPalette.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          heroPalette.directionLabel,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: heroPalette.ink,
                          ),
                        ),
                      ],
                    ),
                  ] else
                    const SizedBox(height: 16),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          heroPalette.sign,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: fullRefundStrike
                                ? _TxDetailColors.ink3
                                : heroPalette.primary,
                            height: 1,
                            decoration: fullRefundStrike
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currency,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: fullRefundStrike
                                ? _TxDetailColors.ink3
                                : _TxDetailColors.ink3,
                            height: 1,
                            decoration: fullRefundStrike
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          amount,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 52,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.03,
                            color: fullRefundStrike
                                ? _TxDetailColors.ink3
                                : _TxDetailColors.ink1,
                            height: 1,
                            decoration: fullRefundStrike
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (refunded && transaction.refundedAmount != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _RefundBanner(transaction: transaction),
                    ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      style: GoogleFonts.outfit(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: _TxDetailColors.ink3,
                      ),
                      children: [
                        const TextSpan(text: 'Created '),
                        TextSpan(
                          text: instant != null
                              ? DateFormat('MMM dd, yyyy').format(instant)
                              : '—',
                          style: const TextStyle(
                            color: _TxDetailColors.ink2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: instant != null
                              ? ' · ${DateFormat('h:mm a').format(instant)}'
                              : '',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _MetaStrip(
                    method: _formatPaymentMethod(transaction.paymentType),
                    reference: _formatReference(transaction),
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

class _RefundBanner extends StatelessWidget {
  const _RefundBanner({required this.transaction});

  final ITransaction transaction;

  @override
  Widget build(BuildContext context) {
    final currency = ProxyService.box.defaultCurrency();
    final amt = transaction.refundedAmount ?? transaction.subTotal ?? 0;
    final partial = isPartialRefund(amt, transaction.subTotal ?? 0);
    final method = transaction.refundMethod == 'momo' ? 'MoMo' : 'Cash';
    final reason = transaction.refundReason ?? '—';
    final when = _transactionInstant(transaction);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _TxDetailColors.lossTint,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF8D4D4)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _TxDetailColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF8D4D4)),
            ),
            child: Center(
              child: TransactionDetailSvgs.icon(
                TransactionDetailSvgs.refresh(),
                size: 18,
                color: _TxDetailColors.loss,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partial
                      ? '$currency ${NumberFormat('#,###').format(amt.round())} refunded'
                      : 'Fully refunded to customer',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _TxDetailColors.lossInk,
                  ),
                ),
                Text(
                  '$reason · via $method${when != null ? ' · ${DateFormat('MMM dd').format(when)}' : ''}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: const Color(0xFFC2696A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final _StatusPresentation status;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width - 72;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
      height: 30,
      padding: const EdgeInsets.only(left: 11, right: 14),
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
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.06 * 12,
              color: status.foreground,
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }
}

class _MetaStrip extends StatelessWidget {
  const _MetaStrip({required this.method, required this.reference});

  final String method;
  final String reference;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _TxDetailColors.line,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _TxDetailColors.line),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            Expanded(child: _MetaCell(label: 'Method', value: method, mono: false)),
            Container(width: 1, height: 52, color: _TxDetailColors.line),
            Expanded(
              child: _MetaCell(
                label: 'Reference',
                value: reference,
                mono: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaCell extends StatelessWidget {
  const _MetaCell({
    required this.label,
    required this.value,
    required this.mono,
  });

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _TxDetailColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.04 * 11,
              color: _TxDetailColors.ink3,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              if (!mono) ...[
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _TxDetailColors.blueTint,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: TransactionDetailSvgs.icon(
                      TransactionDetailSvgs.wallet(),
                      size: 13,
                      color: _TxDetailColors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mono
                      ? GoogleFonts.jetBrainsMono(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _TxDetailColors.ink1,
                        )
                      : GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _TxDetailColors.ink1,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _SectionIconTone { blue, green }

class _TxExpandableSection extends StatelessWidget {
  const _TxExpandableSection({
    required this.iconSvg,
    required this.iconTone,
    required this.title,
    required this.subtitle,
    required this.isOpen,
    required this.reduceMotion,
    required this.onToggle,
    required this.child,
  });

  final String iconSvg;
  final _SectionIconTone iconTone;
  final String title;
  final String subtitle;
  final bool isOpen;
  final bool reduceMotion;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final iconBg = iconTone == _SectionIconTone.blue
        ? _TxDetailColors.blueTint
        : _TxDetailColors.gainTint;
    final iconColor = iconTone == _SectionIconTone.blue
        ? _TxDetailColors.blue
        : _TxDetailColors.gain;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _TxDetailColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _TxDetailColors.line),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onToggle,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: iconBg,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Center(
                            child: TransactionDetailSvgs.icon(
                              iconSvg,
                              size: 21,
                              color: iconColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.01,
                                  color: _TxDetailColors.ink1,
                                ),
                              ),
                              Text(
                                subtitle,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: _TxDetailColors.ink3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: isOpen ? 0.5 : 0,
                          duration: reduceMotion
                              ? Duration.zero
                              : _sectionAnimDuration,
                          curve: _sectionAnimCurve,
                          child: TransactionDetailSvgs.icon(
                            TransactionDetailSvgs.chevronDown(),
                            size: 20,
                            color: _TxDetailColors.ink3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ClipRect(
                child: AnimatedAlign(
                  duration: reduceMotion
                      ? Duration.zero
                      : _sectionAnimDuration,
                  curve: _sectionAnimCurve,
                  heightFactor: isOpen ? 1 : 0,
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductsSectionBody extends StatelessWidget {
  const _ProductsSectionBody({required this.items});

  final List<TransactionItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          'No line items for this transaction.',
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: _TxDetailColors.ink3,
          ),
        ),
      );
    }

    final currency = ProxyService.box.defaultCurrency();
    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.price * item.qty,
    );

    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            const Divider(height: 1, color: _TxDetailColors.lineSoft),
          _ProductRow(item: items[i], currency: currency),
        ],
        const Divider(height: 1, color: _TxDetailColors.lineSoft),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                'Subtotal',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _TxDetailColors.ink2,
                ),
              ),
              const Spacer(),
              Text(
                '$currency ${NumberFormat('#,###').format(subtotal)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _TxDetailColors.ink1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.item, required this.currency});

  final TransactionItem item;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final swatch = _swatchColor(item.name);
    final lineTotal = item.qty * item.price;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: swatch,
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: Text(
              _abbr(item.name),
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: _TxDetailColors.ink1,
                  ),
                ),
                Text(
                  '${item.qty.toInt()} × $currency ${NumberFormat('#,###').format(item.price)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    color: _TxDetailColors.ink3,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$currency ${NumberFormat('#,###').format(lineTotal)}',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: _TxDetailColors.ink1,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineSectionBody extends StatelessWidget {
  const _TimelineSectionBody({required this.events});

  final List<_TimelineEvent> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          'No timeline events yet.',
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: _TxDetailColors.ink3,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Column(
        children: [
          for (var i = 0; i < events.length; i++)
            _TimelineRow(
              event: events[i],
              showConnector: i < events.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event, required this.showConnector});

  final _TimelineEvent event;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: showConnector ? 18 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: event.isRefund
                      ? _TxDetailColors.lossTint
                      : event.done
                          ? _TxDetailColors.gainTint
                          : _TxDetailColors.surface2,
                  border: event.isRefund
                      ? Border.all(color: const Color(0xFFF8D4D4))
                      : event.done
                          ? null
                          : Border.all(color: _TxDetailColors.line),
                ),
                child: Center(
                  child: event.isRefund
                      ? TransactionDetailSvgs.icon(
                          TransactionDetailSvgs.refresh(),
                          size: 14,
                          color: _TxDetailColors.loss,
                        )
                      : event.done
                          ? TransactionDetailSvgs.icon(
                              TransactionDetailSvgs.check(),
                              size: 15,
                              color: _TxDetailColors.gain,
                            )
                          : Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: _TxDetailColors.ink3,
                          ),
                        ),
                ),
              ),
              if (showConnector)
                Container(
                  width: 2,
                  height: 14,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  color: _TxDetailColors.line,
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _TxDetailColors.ink1,
                    ),
                  ),
                  if (event.detail.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      event.detail,
                      style: GoogleFonts.outfit(
                        fontSize: 12.5,
                        color: _TxDetailColors.ink3,
                      ),
                    ),
                  ],
                  if (event.time != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      DateFormat('MMM dd, yyyy · h:mm a').format(event.time!),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11.5,
                        color: _TxDetailColors.ink4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PressScaleButton extends StatefulWidget {
  const _PressScaleButton({
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  static const _pressScale = 0.93;

  @override
  State<_PressScaleButton> createState() => _PressScaleButtonState();
}

class _PressScaleButtonState extends State<_PressScaleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? _PressScaleButton._pressScale : 1,
        duration: const Duration(milliseconds: 100),
        curve: Curves.ease,
        child: widget.child,
      ),
    );
  }
}

class _TimelineEvent {
  const _TimelineEvent({
    required this.title,
    required this.detail,
    required this.done,
    this.time,
    this.isRefund = false,
  });

  final String title;
  final String detail;
  final DateTime? time;
  final bool done;
  final bool isRefund;
}

class _StatusPresentation {
  const _StatusPresentation({
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

DateTime? _transactionInstant(ITransaction t) {
  return t.lastTouched ?? t.updatedAt ?? t.createdAt;
}

_StatusPresentation _statusPresentation(
  String? status, {
  bool isRefunded = false,
  double? refundedAmount,
  double subTotal = 0,
}) {
  final normalized = (status ?? 'unknown').toLowerCase();
  if (isRefunded ||
      normalized == 'refunded' ||
      normalized == 'partially_refunded') {
    final partial = normalized == 'partially_refunded' ||
        (refundedAmount != null &&
            isPartialRefund(refundedAmount, subTotal));
    if (partial) {
      return const _StatusPresentation(
        label: 'PARTIALLY REFUNDED',
        background: _TxDetailColors.pendingTint,
        foreground: _TxDetailColors.pendingInk,
        dot: _TxDetailColors.pendingDot,
      );
    }
    return const _StatusPresentation(
      label: 'REFUNDED',
      background: _TxDetailColors.lossTint,
      foreground: _TxDetailColors.lossInk,
      dot: _TxDetailColors.loss,
    );
  }
  switch (normalized) {
    case 'pending':
    case 'waiting':
    case 'waitingmomocomplete':
      return const _StatusPresentation(
        label: 'PENDING',
        background: _TxDetailColors.pendingTint,
        foreground: _TxDetailColors.pendingInk,
        dot: _TxDetailColors.pendingDot,
      );
    case 'completed':
    case 'complete':
      return const _StatusPresentation(
        label: 'COMPLETED',
        background: _TxDetailColors.gainTint,
        foreground: _TxDetailColors.gainInk,
        dot: _TxDetailColors.gain,
      );
    case 'parked':
      return const _StatusPresentation(
        label: 'PARKED',
        background: _TxDetailColors.blueTint,
        foreground: _TxDetailColors.blue,
        dot: _TxDetailColors.blue,
      );
    default:
      return _StatusPresentation(
        label: (status ?? 'UNKNOWN').toUpperCase(),
        background: _TxDetailColors.surface2,
        foreground: _TxDetailColors.ink2,
        dot: _TxDetailColors.ink3,
      );
  }
}

String _itemCountLabel(int count) {
  if (count == 1) return '1 item';
  return '$count items';
}

String _formatPaymentMethod(String? paymentType) {
  if (paymentType == null || paymentType.trim().isEmpty) {
    return '—';
  }
  final upper = paymentType.toUpperCase();
  if (upper.contains('MOMO') || upper.contains('MOBILE')) return 'MoMo';
  if (upper.contains('CARD')) return 'Card';
  if (upper.contains('CASH')) return 'Cash';
  return paymentType;
}

String _formatReference(ITransaction transaction) {
  final ref = transaction.reference?.trim();
  if (ref != null && ref.isNotEmpty) {
    return ref.startsWith('#') ? ref : '#$ref';
  }
  final id = transaction.id.toString();
  if (id.isEmpty) return '—';
  final short = id.length > 8 ? id.substring(0, 8) : id;
  return '#$short';
}

Color _swatchColor(String name) {
  var hash = 0;
  for (var i = 0; i < name.length; i++) {
    hash = (hash * 31 + name.codeUnitAt(i)) & 0xFFFFFFFF;
  }
  return _productSwatchColors[hash % _productSwatchColors.length];
}

String _abbr(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  return name.length >= 2
      ? name.substring(0, 2).toUpperCase()
      : name.toUpperCase();
}

List<_TimelineEvent> _buildTimeline(ITransaction transaction) {
  final currency = ProxyService.box.defaultCurrency();
  final amount = NumberFormat('#,###').format(transaction.subTotal ?? 0);
  final events = <_TimelineEvent>[];
  final status = (transaction.status ?? '').toLowerCase();
  final isComplete = status == COMPLETE || status == 'complete';

  if (transaction.isRefunded == true) {
    final refundedAmt = transaction.refundedAmount ?? transaction.subTotal ?? 0;
    final partial = isPartialRefund(
      refundedAmt,
      transaction.subTotal ?? 0,
    );
    events.add(
      _TimelineEvent(
        title: partial ? 'Partially refunded' : 'Refunded',
        detail:
            '$currency ${NumberFormat('#,###').format(refundedAmt.round())} · ${transaction.refundReason ?? 'Refund'}',
        time: transaction.updatedAt ?? transaction.lastTouched,
        done: true,
        isRefund: true,
      ),
    );
  }

  if (isComplete) {
    events.add(
      _TimelineEvent(
        title: 'Payment received',
        detail:
            '$currency $amount · ${_formatPaymentMethod(transaction.paymentType)}',
        time: transaction.updatedAt ??
            transaction.lastTouched ??
            transaction.createdAt,
        done: true,
      ),
    );
  } else if (status == PENDING || status == WAITING) {
    events.add(
      _TimelineEvent(
        title: 'Payment pending',
        detail: _formatPaymentMethod(transaction.paymentType),
        time: transaction.updatedAt ?? transaction.createdAt,
        done: false,
      ),
    );
  }

  if (transaction.createdAt != null) {
    events.add(
      _TimelineEvent(
        title: 'Sale created',
        detail: transaction.paymentType != null
            ? 'Payment: ${transaction.paymentType}'
            : '',
        time: transaction.createdAt,
        done: isComplete,
      ),
    );
  }

  return events;
}
