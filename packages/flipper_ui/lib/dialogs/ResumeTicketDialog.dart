import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/widgets/async_action_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// MPOS resume-ticket tokens (design_handoff_mobile_pos).
const Color _kPrimary = Color(0xFF2563EB);
const Color _kInk = Color(0xFF111827);
const Color _kLabel = Color(0xFF9CA3AF);
const Color _kCardBorder = Color(0xFFE5E7EB);
const Color _kLoanPurple = Color(0xFF6B4EA2);
const Color _kDueRed = Color(0xFFDC2626);
const Color _kPaidGreen = Color(0xFF16A34A);
const Color _kParkedOrange = Color(0xFFD97706);
const Color _kParkedBg = Color(0xFFFFF7ED);
const double _kSheetRadius = 26;

const _monthShort = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Space below scroll content so [UPDATE STATUS] stays above [stickyActionBar].
/// Matches footer padding (12+52+20) plus clearance and device safe area.
double _resumeTicketScrollBottomInset(BuildContext context) {
  const footerHeight = 14.0 + 56.0 + 20.0;
  const clearance = 12.0;
  return footerHeight + clearance + MediaQuery.paddingOf(context).bottom;
}

/// Helper to show the resume-ticket sheet (bottom sheet on mobile, dialog on wide).
Future<void> showResumeTicketDialog({
  required BuildContext context,
  required ITransaction ticket,
  required Future<void> Function(ITransaction) onResume,
  required Function(String) onStatusChange,
}) {
  final useBottomSheet = MediaQuery.sizeOf(context).width < 600;
  final isResuming = ValueNotifier(false);

  return WoltModalSheet.show(
    context: context,
    enableDrag: useBottomSheet,
    barrierDismissible: true,
    modalTypeBuilder: (context) =>
        useBottomSheet ? WoltModalType.bottomSheet() : WoltModalType.dialog(),
    pageListBuilder: (context) {
      return [
        _buildResumeTicketPage(
          context,
          ticket,
          onResume,
          onStatusChange,
          isResuming,
          useBottomSheet: useBottomSheet,
        ),
      ];
    },
  ).whenComplete(isResuming.dispose);
}

SliverWoltModalSheetPage _buildResumeTicketPage(
  BuildContext context,
  ITransaction ticket,
  Future<void> Function(ITransaction) onResume,
  Function(String) onStatusChange,
  ValueNotifier<bool> isResuming, {
  required bool useBottomSheet,
}) {
  return SliverWoltModalSheetPage(
    backgroundColor: Colors.white,
    hasTopBarLayer: false,
    forceMaxHeight: useBottomSheet,
    pageTitle: const SizedBox.shrink(),
    mainContentSliversBuilder: (_) => [
      SliverToBoxAdapter(
        child: ClipRRect(
          borderRadius: useBottomSheet
              ? const BorderRadius.vertical(top: Radius.circular(_kSheetRadius))
              : BorderRadius.zero,
          child: ResumeTicketSummary(
            ticket: ticket,
            onStatusChange: onStatusChange,
            isResuming: isResuming,
          ),
        ),
      ),
    ],
    stickyActionBar: _ResumeTicketFooter(
      ticket: ticket,
      onResume: onResume,
      isResumingNotifier: isResuming,
    ),
  );
}

class _ResumeTicketFooter extends ConsumerStatefulWidget {
  const _ResumeTicketFooter({
    required this.ticket,
    required this.onResume,
    required this.isResumingNotifier,
  });

  final ITransaction ticket;
  final Future<void> Function(ITransaction) onResume;
  final ValueNotifier<bool> isResumingNotifier;

  @override
  ConsumerState<_ResumeTicketFooter> createState() => _ResumeTicketFooterState();
}

class _ResumeTicketFooterState extends ConsumerState<_ResumeTicketFooter> {
  @override
  Widget build(BuildContext context) {
    final currency = ProxyService.box.defaultCurrency();
    final totalPaidAsync =
        ref.watch(transactionTotalPaidProvider(widget.ticket.id));

    return totalPaidAsync.when(
      data: (paid) {
        final total = widget.ticket.subTotal ?? 0.0;
        final due = (total - paid).clamp(0.0, double.infinity);
        final dueText = due.toCurrencyFormatted(symbol: currency);

        return ValueListenableBuilder<bool>(
          valueListenable: widget.isResumingNotifier,
          builder: (context, isResuming, _) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: _kCardBorder)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isResuming)
                    const LinearProgressIndicator(
                      minHeight: 2,
                      backgroundColor: Color(0xFFF3F4F6),
                      valueColor: AlwaysStoppedAnimation<Color>(_kPrimary),
                    ),
                  SafeArea(
                    top: false,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'DUE',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: _kLabel,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dueText,
                                style: _monoStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: _kDueRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 6,
                          child: AsyncActionGradientButton(
                            idleLabel: 'Resume order',
                            loadingLabel: 'Resuming…',
                            icon: Icons.replay_rounded,
                            syncNotifier: widget.isResumingNotifier,
                            onPressed: () async {
                              await widget.onResume(widget.ticket);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const SizedBox(height: 88),
      error: (_, __) => const SizedBox(height: 88),
    );
  }
}

class ResumeTicketSummary extends ConsumerStatefulWidget {
  const ResumeTicketSummary({
    super.key,
    required this.ticket,
    required this.onStatusChange,
    required this.isResuming,
  });

  final ITransaction ticket;
  final Function(String) onStatusChange;
  final ValueNotifier<bool> isResuming;

  @override
  ConsumerState<ResumeTicketSummary> createState() =>
      _ResumeTicketSummaryState();
}

class _ResumeTicketSummaryState extends ConsumerState<ResumeTicketSummary> {
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    final itemsAsync = ref.watch(transactionItemsStreamProvider(
      transactionId: ticket.id,
      branchId: ticket.branchId ?? ProxyService.box.getBranchId()!,
    ));
    final totalPaidAsync =
        ref.watch(transactionTotalPaidProvider(ticket.id));
    final currency = ProxyService.box.defaultCurrency();

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: _resumeTicketScrollBottomInset(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetHandle(),
          ValueListenableBuilder<bool>(
            valueListenable: widget.isResuming,
            builder: (context, isResuming, _) => _ResumeHeader(
              ticket: ticket,
              onClose: isResuming ? null : () => Navigator.of(context).pop(),
            ),
          ),
          if (_isUpdating) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Color(0xFFF3F4F6),
              valueColor: AlwaysStoppedAnimation<Color>(_kPrimary),
            ),
          ],
          const SizedBox(height: 22),
          _sectionLabel('CUSTOMER'),
          const SizedBox(height: 8),
          _CustomerCard(ticket: ticket),
          const SizedBox(height: 20),
          itemsAsync.when(
            data: (items) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('ITEMS · ${items.length}'),
                  const SizedBox(height: 8),
                  totalPaidAsync.when(
                    data: (paid) => _ItemsAndTotalsCard(
                      items: items,
                      ticket: ticket,
                      paid: paid,
                      currency: currency,
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: _kPrimary,
                        ),
                      ),
                    ),
                    error: (_, __) => _ItemsAndTotalsCard(
                      items: items,
                      ticket: ticket,
                      paid: 0,
                      currency: currency,
                    ),
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: _kPrimary,
                ),
              ),
            ),
            error: (e, _) => Text(
              'Could not load items: $e',
              style: GoogleFonts.poppins(fontSize: 13, color: _kDueRed),
            ),
          ),
          const SizedBox(height: 24),
          _sectionLabel('UPDATE STATUS'),
          const SizedBox(height: 10),
          _StatusRow(
            currentStatus: ticket.status ?? PARKED,
            isUpdating: _isUpdating,
            onSelect: (value) async {
              if (ticket.status == value || _isUpdating) return;
              setState(() => _isUpdating = true);
              try {
                await widget.onStatusChange(value);
              } finally {
                if (mounted) setState(() => _isUpdating = false);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ResumeHeader extends StatelessWidget {
  const _ResumeHeader({required this.ticket, this.onClose});

  final ITransaction ticket;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final badge = _statusBadgeFor(ticket.status ?? PARKED);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFFEEF4FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.schedule_rounded,
            color: _kPrimary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Resume ticket',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: _kInk,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badge.bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: badge.fg,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          badge.label,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: badge.fg,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '#${_ticketRef(ticket)}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _kLabel,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        Opacity(
          opacity: onClose == null ? 0.4 : 1,
          child: Material(
            color: const Color(0xFFF3F4F6),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onClose,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Icon(Icons.close, size: 18, color: _kInk),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.ticket});

  final ITransaction ticket;

  @override
  Widget build(BuildContext context) {
    final name = (ticket.customerName ?? ticket.ticketName ?? 'Walk-in').trim();
    final phone = (ticket.customerPhone ??
            ticket.currentSaleCustomerPhoneNumber ??
            '')
        .trim();
    final initial = _customerInitial(name);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _surfaceCard(
          backgroundColor: const Color(0xFFF8FAFC),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4A9EFF), Color(0xFF2563EB)],
                  ),
                ),
                child: Text(
                  initial,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: _kInk,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (phone.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone_android_rounded,
                              size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 6),
                          Text(
                            _formatPhoneDisplay(phone),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (ticket.isLoan == true)
              _infoTag(
                label: 'Loan',
                icon: Icons.account_balance_wallet_outlined,
                fg: _kLoanPurple,
                bg: const Color(0xFFF3E5F5),
              ),
            if (name == 'Walk-in')
              _infoTag(
                label: 'Walk-in',
                icon: Icons.person_outline_rounded,
                fg: const Color(0xFF6B7280),
                bg: Colors.white,
                bordered: true,
              ),
            _infoTag(
              label: _formatTicketDate(ticket.createdAt),
              icon: Icons.calendar_today_outlined,
              fg: const Color(0xFF6B7280),
              bg: Colors.white,
              bordered: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _ItemsAndTotalsCard extends StatelessWidget {
  const _ItemsAndTotalsCard({
    required this.items,
    required this.ticket,
    required this.paid,
    required this.currency,
  });

  final List<TransactionItem> items;
  final ITransaction ticket;
  final double paid;
  final String currency;

  static const _swatchColors = [
    Color(0xFF3B82F6),
    Color(0xFF7C3AED),
    Color(0xFF2563EB),
    Color(0xFF6B4EA2),
  ];

  @override
  Widget build(BuildContext context) {
    final total = ticket.subTotal ?? 0.0;
    final remaining = (total - paid).clamp(0.0, double.infinity);

    return _surfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No items on this ticket.',
                style: GoogleFonts.poppins(fontSize: 14, color: _kLabel),
              ),
            )
          else
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: _kCardBorder),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: _ItemRow(
                  item: items[i],
                  swatchColor: _swatchColors[i % _swatchColors.length],
                  currency: currency,
                ),
              ),
            ],
          const Divider(height: 1, color: _kCardBorder),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              children: [
                _moneyRow(
                  'Total amount',
                  total.toCurrencyFormatted(symbol: currency),
                ),
                const SizedBox(height: 10),
                _moneyRow(
                  'Amount paid',
                  paid.toCurrencyFormatted(symbol: currency),
                  valueColor: _kPaidGreen,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: _DashedDivider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Remaining balance',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _kInk,
                      ),
                    ),
                    Text(
                      remaining.toCurrencyFormatted(symbol: currency),
                      style: _monoStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _kDueRed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.item,
    required this.swatchColor,
    required this.currency,
  });

  final TransactionItem item;
  final Color swatchColor;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final lineTotal = item.qty * item.price;
    final initials = _itemInitials(item.name);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: swatchColor,
            shape: BoxShape.circle,
          ),
          child: Text(
            initials,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 11,
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
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: _kInk,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${item.qty} x ${item.price.toCurrencyFormatted(symbol: currency)}',
                style: GoogleFonts.poppins(fontSize: 12, color: _kLabel),
              ),
            ],
          ),
        ),
        Text(
          lineTotal.toCurrencyFormatted(symbol: currency),
          style: _monoStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _kInk,
          ),
        ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.currentStatus,
    required this.isUpdating,
    required this.onSelect,
  });

  final String currentStatus;
  final bool isUpdating;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatusCard(
            label: 'Waiting',
            dotColor: _kParkedOrange,
            isSelected: _isWaitingStatus(currentStatus),
            onTap: isUpdating ? null : () => onSelect(PARKED),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatusCard(
            label: 'In Progress',
            dotColor: const Color(0xFF2563EB),
            isSelected: currentStatus == IN_PROGRESS || currentStatus == ORDERING,
            onTap: isUpdating ? null : () => onSelect(IN_PROGRESS),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatusCard(
            label: 'Completed',
            dotColor: _kPaidGreen,
            isSelected: currentStatus == COMPLETE,
            onTap: isUpdating ? null : () => onSelect(COMPLETE),
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.label,
    required this.dotColor,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color dotColor;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEEF4FF) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? _kPrimary : _kCardBorder,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? _kPrimary : _kInk,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              if (isSelected)
                Positioned(
                  top: -6,
                  right: -4,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_circle, size: 18, color: _kPrimary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFD1D5DB),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
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
        final count = (constraints.maxWidth / (dashWidth * 2)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(
              width: dashWidth,
              height: 1,
              color: Colors.grey.shade300,
            ),
          ),
        );
      },
    );
  }
}

Widget _sectionLabel(String text) {
  return Text(
    text,
    style: GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.9,
      color: _kLabel,
    ),
  );
}

Widget _surfaceCard({
  required Widget child,
  EdgeInsetsGeometry? padding,
  Color backgroundColor = Colors.white,
}) {
  return Container(
    width: double.infinity,
    padding: padding ?? const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _kCardBorder),
    ),
    child: child,
  );
}

Widget _moneyRow(String label, String value, {Color? valueColor}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey.shade700,
        ),
      ),
      Text(
        value,
        style: _monoStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: valueColor ?? _kInk,
        ),
      ),
    ],
  );
}

Widget _infoTag({
  required String label,
  required IconData icon,
  required Color fg,
  required Color bg,
  bool bordered = false,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      border: bordered ? Border.all(color: _kCardBorder) : null,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: fg),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: fg,
          ),
        ),
      ],
    ),
  );
}

TextStyle _monoStyle({
  required double fontSize,
  FontWeight fontWeight = FontWeight.w500,
  Color color = _kInk,
}) {
  return GoogleFonts.jetBrainsMono(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: -0.2,
  );
}

class _StatusBadge {
  const _StatusBadge(this.label, this.fg, this.bg);
  final String label;
  final Color fg;
  final Color bg;
}

_StatusBadge _statusBadgeFor(String status) {
  switch (status) {
    case IN_PROGRESS:
    case ORDERING:
      return const _StatusBadge(
        'IN PROGRESS',
        Color(0xFF2563EB),
        Color(0xFFE3F2FD),
      );
    case COMPLETE:
      return const _StatusBadge('COMPLETED', _kPaidGreen, Color(0xFFE8F5E9));
    case PARKED:
    case PENDING:
    case WAITING:
    default:
      return const _StatusBadge('PARKED', _kParkedOrange, _kParkedBg);
  }
}

bool _isWaitingStatus(String status) {
  return status == PARKED ||
      status == PENDING ||
      status == WAITING ||
      status.isEmpty;
}

String _ticketRef(ITransaction ticket) {
  final r = ticket.reference?.trim();
  if (r != null && r.isNotEmpty) return r.toUpperCase();
  final id = ticket.id;
  if (id.length >= 8) return id.substring(0, 8).toUpperCase();
  return id.toUpperCase();
}

String _customerInitial(String name) {
  if (name.isEmpty) return '?';
  final parts = name.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  final single = parts[0];
  return single.length >= 1 ? single[0].toUpperCase() : '?';
}

String _itemInitials(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '??';
  final parts = trimmed.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  if (trimmed.length >= 2) return trimmed.substring(0, 2).toUpperCase();
  return trimmed[0].toUpperCase();
}

String _formatTicketDate(DateTime? date) {
  if (date == null) return '—';
  final local = date.toLocal();
  final m = _monthShort[local.month - 1];
  return '${local.day} $m ${local.year}';
}

String _formatPhoneDisplay(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 10) {
    return '${digits.substring(0, 4)} ${digits.substring(4, 7)} '
        '${digits.substring(7)}';
  }
  if (digits.length == 12 && digits.startsWith('250')) {
    final local = digits.substring(3);
    return '${local.substring(0, 4)} ${local.substring(4, 7)} '
        '${local.substring(7)}';
  }
  return raw;
}
