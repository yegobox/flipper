import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/widgets/sheet_dismiss_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _kReviewPurple = Color(0xFF7C3AED);
const Color _kInk = Color(0xFF111827);
const Color _kLabel = Color(0xFF9CA3AF);
const Color _kCardBorder = Color(0xFFE5E7EB);
const Color _kPaidGreen = Color(0xFF16A34A);

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

/// Read-only ticket review content: line items + payment channels + approve.
///
/// Use as a desktop side panel ([panelMode] true, matches Customers) or inside
/// a mobile bottom sheet ([showReviewTicketDialog]).
class ReviewTicketPanel extends ConsumerStatefulWidget {
  const ReviewTicketPanel({
    super.key,
    required this.ticket,
    required this.onMarkReviewed,
    this.canReview = true,
    this.panelMode = false,
    this.showSheetHandle = true,
    this.onDismissed,
    this.onReviewed,
  });

  final ITransaction ticket;
  final Future<void> Function(ITransaction ticket) onMarkReviewed;
  final bool canReview;
  final bool panelMode;
  final bool showSheetHandle;
  final VoidCallback? onDismissed;

  /// Called after a successful mark-reviewed (before [onDismissed] if both set).
  final VoidCallback? onReviewed;

  @override
  ConsumerState<ReviewTicketPanel> createState() => _ReviewTicketPanelState();
}

class _ReviewTicketPanelState extends ConsumerState<ReviewTicketPanel> {
  bool _saving = false;

  Future<void> _handleMarkReviewed() async {
    if (_saving || !widget.canReview) return;
    setState(() => _saving = true);
    try {
      await widget.onMarkReviewed(widget.ticket);
      if (!mounted) return;
      // Success path: prefer [onReviewed]; do not also call [onDismissed]
      // (mobile sheet would pop twice).
      if (widget.onReviewed != null) {
        widget.onReviewed!();
      } else {
        widget.onDismissed?.call();
      }
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _dismiss() {
    if (_saving) return;
    widget.onDismissed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final paidAsync = ref.watch(transactionTotalPaidProvider(widget.ticket.id));
    final branchId =
        widget.ticket.branchId ?? ProxyService.box.getBranchId()!;
    final itemsAsync = ref.watch(
      transactionItemsStreamProvider(
        transactionId: widget.ticket.id,
        branchId: branchId,
      ),
    );
    final currency = ProxyService.box.defaultCurrency();

    final scrollBody = Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        widget.showSheetHandle ? 8 : 16,
        20,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showSheetHandle) const _SheetHandle(),
          _Header(
            ticket: widget.ticket,
            onClose: _saving ? null : _dismiss,
          ),
          const SizedBox(height: 22),
          _sectionLabel('CUSTOMER'),
          const SizedBox(height: 8),
          _CustomerCard(ticket: widget.ticket),
          const SizedBox(height: 20),
          itemsAsync.when(
            data: (items) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('ITEMS · ${items.length}'),
                const SizedBox(height: 8),
                paidAsync.when(
                  data: (paid) => _ItemsAndTotalsCard(
                    items: items,
                    ticket: widget.ticket,
                    paid: paid,
                    currency: currency,
                  ),
                  loading: () => const _LoadingBlock(),
                  error: (_, __) => _ItemsAndTotalsCard(
                    items: items,
                    ticket: widget.ticket,
                    paid: widget.ticket.cashReceived ?? 0,
                    currency: currency,
                  ),
                ),
              ],
            ),
            loading: () => const _LoadingBlock(),
            error: (e, _) => Text(
              'Could not load items: $e',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.red),
            ),
          ),
          const SizedBox(height: 20),
          _sectionLabel('PAYMENT'),
          const SizedBox(height: 8),
          _PaymentsCard(
            key: ValueKey('pay-${widget.ticket.id}'),
            ticket: widget.ticket,
            currency: currency,
          ),
          if ((widget.ticket.note ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 20),
            _sectionLabel('NOTE'),
            const SizedBox(height: 8),
            _surfaceCard(
              backgroundColor: const Color(0xFFF8FAFC),
              child: Text(
                widget.ticket.note!.trim(),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: _kInk,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    final footer = widget.canReview
        ? _ReviewTicketFooter(
            isSaving: _saving,
            onPressed: _handleMarkReviewed,
          )
        : null;

    if (widget.panelMode) {
      return ColoredBox(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: SingleChildScrollView(child: scrollBody)),
            if (footer != null) footer,
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: SingleChildScrollView(child: scrollBody)),
        if (footer != null) footer,
      ],
    );
  }
}

/// Mobile bottom sheet host for [ReviewTicketPanel]. Desktop Review Queue uses
/// the panel inline instead.
Future<bool?> showReviewTicketDialog({
  required BuildContext context,
  required ITransaction ticket,
  required Future<void> Function(ITransaction) onMarkReviewed,
  bool canReview = true,
}) {
  final sheetHeight = MediaQuery.sizeOf(context).height * 0.92;
  return showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    constraints: BoxConstraints(maxHeight: sheetHeight),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (sheetContext) {
      return SizedBox(
        height: sheetHeight,
        child: ReviewTicketPanel(
          ticket: ticket,
          canReview: canReview,
          panelMode: true,
          showSheetHandle: true,
          onDismissed: () {
            if (Navigator.of(sheetContext).canPop()) {
              Navigator.of(sheetContext).pop(false);
            }
          },
          onReviewed: () {
            if (Navigator.of(sheetContext).canPop()) {
              Navigator.of(sheetContext).pop(true);
            }
          },
          onMarkReviewed: onMarkReviewed,
        ),
      );
    },
  );
}

class _ReviewTicketFooter extends StatelessWidget {
  const _ReviewTicketFooter({
    required this.isSaving,
    required this.onPressed,
  });

  final bool isSaving;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _kCardBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSaving)
            const LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Color(0xFFF3F4F6),
              valueColor: AlwaysStoppedAnimation<Color>(_kReviewPurple),
            ),
          SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: isSaving ? null : onPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: _kReviewPurple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      _kReviewPurple.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.fact_check_outlined, size: 20),
                label: Text(
                  isSaving ? 'Marking…' : 'Mark as reviewed',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.ticket, this.onClose});

  final ITransaction ticket;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFFF3E8FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.fact_check_outlined,
            color: _kReviewPurple,
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
                      'Review ticket',
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: _kReviewPurple,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'PENDING REVIEW',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: _kReviewPurple,
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
        SheetDismissButton(onPressed: onClose),
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
    final phone =
        (ticket.customerPhone ?? ticket.currentSaleCustomerPhoneNumber ?? '')
            .trim();
    final cashier = (ticket.cashierName ?? '').trim();

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
                    colors: [Color(0xFFA78BFA), _kReviewPurple],
                  ),
                ),
                child: Text(
                  _customerInitial(name),
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
                          Icon(
                            Icons.phone_android_rounded,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
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
            if (cashier.isNotEmpty)
              _infoTag(
                label: cashier,
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
    Color(0xFF7C3AED),
    Color(0xFF3B82F6),
    Color(0xFF2563EB),
    Color(0xFF6B4EA2),
  ];

  @override
  Widget build(BuildContext context) {
    final total = ticket.subTotal ?? 0.0;

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

    return Row(
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
            _itemInitials(item.name),
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
          style: FlipperFonts.mono(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _kInk,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _PaymentsCard extends StatefulWidget {
  const _PaymentsCard({super.key, required this.ticket, required this.currency});

  final ITransaction ticket;
  final String currency;

  @override
  State<_PaymentsCard> createState() => _PaymentsCardState();
}

class _PaymentsCardState extends State<_PaymentsCard> {
  late Future<List<TransactionPaymentRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadPayments();
  }

  @override
  void didUpdateWidget(covariant _PaymentsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ticket.id != widget.ticket.id) {
      _future = _loadPayments();
    }
  }

  Future<List<TransactionPaymentRecord>> _loadPayments() async {
    try {
      final records = await ProxyService.strategy.getPaymentType(
        transactionId: widget.ticket.id,
      );
      return List<TransactionPaymentRecord>.from(records);
    } catch (_) {
      return const <TransactionPaymentRecord>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionPaymentRecord>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const _LoadingBlock();
        }

        final records = snap.data ?? const <TransactionPaymentRecord>[];
        if (records.isEmpty) {
          final fallbackMethod =
              (widget.ticket.paymentType ?? 'Unknown').trim();
          final fallbackAmount =
              widget.ticket.cashReceived ?? widget.ticket.subTotal ?? 0.0;
          return _surfaceCard(
            child: _PaymentRow(
              method: fallbackMethod,
              amount: fallbackAmount,
              currency: widget.currency,
            ),
          );
        }

        return _surfaceCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < records.length; i++) ...[
                if (i > 0) const Divider(height: 1, color: _kCardBorder),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: _PaymentRow(
                    method: records[i].paymentMethod ?? 'Unknown',
                    amount: records[i].amount ?? 0,
                    currency: widget.currency,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.method,
    required this.amount,
    required this.currency,
  });

  final String method;
  final num amount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF3E8FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.payments_outlined,
            size: 18,
            color: _kReviewPurple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            method.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _kInk,
            ),
          ),
        ),
        Text(
          amount.toCurrencyFormatted(symbol: currency),
          style: FlipperFonts.mono(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _kPaidGreen,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: _kReviewPurple,
        ),
      ),
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
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700),
      ),
      Text(
        value,
        style: FlipperFonts.mono(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: valueColor ?? _kInk,
          letterSpacing: -0.2,
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
  return single.isNotEmpty ? single[0].toUpperCase() : '?';
}

String _itemInitials(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '??';
  final parts =
      trimmed.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
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
