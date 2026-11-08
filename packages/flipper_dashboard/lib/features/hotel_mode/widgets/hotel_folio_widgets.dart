import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_shared_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flipper_services/payment_methods.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

final _money = NumberFormat('#,###');

String hotelMoney(num value) => 'RWF ${_money.format(value)}';

/// Guest + dates block at the top of the folio.
class HotelFolioHeaderCard extends StatelessWidget {
  const HotelFolioHeaderCard({
    super.key,
    required this.stay,
    this.compact = false,
    this.onChangeDeparture,
  });

  final HotelStay stay;
  final bool compact;

  /// When set, the departure date is tappable: extend or shorten the stay.
  final VoidCallback? onChangeDeparture;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final due = hotelStayIsDue(stay);
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
        border: Border.all(color: HotelTokens.line),
        boxShadow: HotelTokens.shadow1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  stay.guestName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: compact ? 17 : 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: HotelTokens.ink1,
                  ),
                ),
              ),
              if (due)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4.5,
                  ),
                  decoration: BoxDecoration(
                    color: HotelTokens.dirtyTint,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.hotelDueOut,
                    style: GoogleFonts.outfit(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: HotelTokens.dirtyInk,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            hotelStaySummaryText(l10n, stay),
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: HotelTokens.ink3,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _stat(
                  l10n.hotelArrival,
                  DateFormat('d MMM, HH:mm').format(stay.checkInAt.toLocal()),
                ),
              ),
              Expanded(
                child: onChangeDeparture == null
                    ? _stat(
                        l10n.hotelDeparture,
                        DateFormat(
                          'd MMM, HH:mm',
                        ).format(stay.expectedCheckOutAt.toLocal()),
                      )
                    : InkWell(
                        key: const ValueKey('hotel-change-departure'),
                        onTap: onChangeDeparture,
                        borderRadius: BorderRadius.circular(
                          HotelTokens.radiusMd,
                        ),
                        // No Tooltip: under DevicePreview it trips a layout
                        // assert in this app (see the quotation menu).
                        child: Semantics(
                          button: true,
                          label: l10n.hotelChangeDeparture,
                          child: _stat(
                            l10n.hotelDeparture,
                            DateFormat(
                              'd MMM, HH:mm',
                            ).format(stay.expectedCheckOutAt.toLocal()),
                            trailing: Icons.edit_calendar_outlined,
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: _stat(l10n.hotelRate, hotelMoney(stay.nightlyRate)),
              ),
            ],
          ),
          if (stay.advances.isNotEmpty) ...[
            const SizedBox(height: 12),
            HotelAdvanceList(advances: stay.advances),
          ],
        ],
      ),
    );
  }

  Widget _stat(String label, String value, {IconData? trailing}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: HotelTokens.ink3,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 4),
              Icon(trailing, size: 13, color: HotelTokens.blue),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: HotelTokens.ink1,
          ),
        ),
      ],
    );
  }
}

/// Every advance on a stay: when, how, how much, and what became of it.
class HotelAdvanceList extends StatelessWidget {
  const HotelAdvanceList({super.key, required this.advances});

  final List<HotelAdvance> advances;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.hotelAdvances,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: HotelTokens.ink3,
          ),
        ),
        for (final advance in advances)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${DateFormat('d MMM').format(advance.paidAt.toLocal())}'
                    ' · ${hotelAdvanceMethodLabel(l10n, advance.paymentMethod)}'
                    ' · ${hotelAdvanceStatusLabel(l10n, advance.status)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: advance.isHeld
                          ? HotelTokens.ink2
                          : HotelTokens.ink3,
                    ),
                  ),
                ),
                Text(
                  hotelMoney(advance.amount.round()),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: advance.isHeld ? HotelTokens.ink1 : HotelTokens.ink3,
                    decoration: advance.status == HotelAdvanceStatus.refunded
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Localized label of a tender wire value.
String hotelAdvanceMethodLabel(FlipperAppLocalizations l10n, String method) {
  switch (method) {
    case 'Cash':
      return l10n.cash;
    case kMobileMoney:
      return l10n.paymentMobileMoney;
    case 'DEBIT&CREDIT CARD':
      return l10n.hotelPaymentCard;
    default:
      return method;
  }
}

String hotelAdvanceStatusLabel(
  FlipperAppLocalizations l10n,
  HotelAdvanceStatus status,
) {
  switch (status) {
    case HotelAdvanceStatus.held:
      return l10n.hotelAdvanceHeld;
    case HotelAdvanceStatus.applied:
      return l10n.hotelAdvanceApplied;
    case HotelAdvanceStatus.refunded:
      return l10n.hotelAdvanceRefunded;
  }
}

/// One charge on the folio, with qty controls.
class HotelFolioLineTile extends StatelessWidget {
  const HotelFolioLineTile({
    super.key,
    required this.line,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
    this.readOnly = false,
  });

  final TransactionItem line;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    // On a phone the fixed-width qty, amount and delete controls left the
    // item name a few characters, so they move to a second row there.
    final compact = HotelLayoutScope.maybeMobileOf(context) ?? false;
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line.name,
          maxLines: compact ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: HotelTokens.ink1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${context.flipperL10n.hotelPriceEach(hotelMoney(line.price))}'
          '${line.loggedByName == null ? '' : ' · ${line.loggedByName}'}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: HotelTokens.ink3,
          ),
        ),
      ],
    );
    final amount = Text(
      hotelMoney(line.price * line.qty),
      textAlign: TextAlign.right,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: HotelTokens.ink1,
      ),
    );
    final qty = readOnly
        ? <Widget>[
            Text(
              '× ${line.qty.toInt()}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: HotelTokens.ink3,
              ),
            ),
          ]
        : <Widget>[
            _qtyButton(Icons.remove, onDecrement, compact: compact),
            SizedBox(
              width: 34,
              child: Text(
                '${line.qty.toInt()}',
                textAlign: TextAlign.center,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: HotelTokens.ink1,
                ),
              ),
            ),
            _qtyButton(Icons.add, onIncrement, compact: compact),
          ];
    final delete = IconButton(
      onPressed: onDelete,
      icon: const Icon(Icons.delete_outline, size: 18, color: HotelTokens.ink3),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
        border: Border.all(color: HotelTokens.line),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: info),
                    const SizedBox(width: 12),
                    amount,
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // One stepper pill, as on the check-in sheet, so the
                    // controls read as a single quantity control.
                    if (readOnly)
                      ...qty
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: HotelTokens.surface2,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: HotelTokens.line),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: qty,
                        ),
                      ),
                    const Spacer(),
                    if (!readOnly) delete,
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: info),
                ...qty,
                SizedBox(width: readOnly ? 12 : 6),
                SizedBox(width: 96, child: amount),
                if (!readOnly) delete,
              ],
            ),
    );
  }

  Widget _qtyButton(
    IconData icon,
    VoidCallback onTap, {
    required bool compact,
  }) {
    // A thumb-sized target on a phone; the desk keeps its dense row.
    final size = compact ? 40.0 : 32.0;
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: HotelTokens.ink2),
      ),
    );
  }
}

/// Subtotal / VAT / total block, then advance and balance when the guest has
/// paid ahead.
class HotelFolioTotals extends StatelessWidget {
  const HotelFolioTotals({super.key, required this.lines, this.advance = 0});

  final List<TransactionItem> lines;

  /// Booking advances still held on the stay.
  final double advance;

  @override
  Widget build(BuildContext context) {
    // Taken from the lines: a folio mixes 3% tourism tax on room nights with
    // 18% VAT on whatever the bar charged to the room, so one inclusive rate
    // would be wrong for both.
    final breakdown = hotelFolioTaxBreakdown(lines);
    final l10n = context.flipperL10n;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HotelTokens.surface2,
        borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
        border: Border.all(color: HotelTokens.line),
      ),
      child: Column(
        children: [
          _row(l10n.subtotal, breakdown.subtotal),
          const SizedBox(height: 6),
          _row(l10n.hotelTaxIncl, breakdown.tax),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: HotelTokens.line),
          ),
          _row(l10n.hotelFolioTotal, breakdown.total, emphasis: true),
          if (advance > 0) ...[
            const SizedBox(height: 10),
            HotelAdvanceBalanceRows(total: breakdown.total, advance: advance),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, double value, {bool emphasis = false}) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: emphasis ? 15 : 13,
            fontWeight: emphasis ? FontWeight.w800 : FontWeight.w600,
            color: emphasis ? HotelTokens.ink1 : HotelTokens.ink3,
          ),
        ),
        const Spacer(),
        Text(
          hotelMoney(value.round()),
          style: GoogleFonts.jetBrainsMono(
            fontSize: emphasis ? 17 : 13.5,
            fontWeight: FontWeight.w700,
            color: HotelTokens.ink1,
          ),
        ),
      ],
    );
  }
}

/// "Advance paid −X" and "Balance due Y" (or "To refund" when the advance
/// exceeds the folio). Shared by the folio totals and the checkout dialog, so
/// both read the same figures.
class HotelAdvanceBalanceRows extends StatelessWidget {
  const HotelAdvanceBalanceRows({
    super.key,
    required this.total,
    required this.advance,
  });

  final double total;
  final double advance;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final plan = HotelAdvanceSettlement.of(total: total, held: advance);
    return Column(
      children: [
        _line(l10n.hotelAdvancePaid, '−${hotelMoney(advance.round())}'),
        const SizedBox(height: 6),
        if (plan.surplus > 0)
          _line(
            l10n.hotelAdvanceToRefund,
            hotelMoney(plan.surplus.round()),
            emphasis: true,
          )
        else
          _line(
            l10n.hotelBalanceDue,
            hotelMoney(plan.balance.round()),
            emphasis: true,
          ),
      ],
    );
  }

  Widget _line(String label, String value, {bool emphasis = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: emphasis ? 14 : 13,
              fontWeight: emphasis ? FontWeight.w800 : FontWeight.w600,
              color: emphasis ? HotelTokens.ink1 : HotelTokens.ink3,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: emphasis ? 15 : 13.5,
            fontWeight: FontWeight.w700,
            color: HotelTokens.ink1,
          ),
        ),
      ],
    );
  }
}

/// What the desk chose on the checkout dialog.
class HotelCheckOutResult {
  const HotelCheckOutResult({
    required this.paymentType,
    required this.cashReceived,
    required this.changeDue,
  });

  final String paymentType;
  final double cashReceived;
  final double changeDue;
}

/// Payment capture at checkout. Cash requires a tender that covers what is
/// due; the non-cash rails settle at exactly that amount.
///
/// What is due is the folio less any [advance] the guest already paid. With
/// [allowCredit] a fourth rail puts the balance on credit (ideni) instead.
class HotelCheckOutDialog extends StatefulWidget {
  const HotelCheckOutDialog({
    super.key,
    required this.total,
    this.mobile = false,
    this.advance = 0,
    this.allowCredit = false,
  });

  final double total;

  /// Paid before checkout (booking advances still held). Deducted, never
  /// collected twice.
  final double advance;

  /// Offer the Credit rail.
  final bool allowCredit;

  /// Wire value the dialog returns when the balance goes on credit.
  static const creditTender = 'CREDIT';

  /// Drawn as a phone bottom sheet: grab bar, top-only corners, the bar's
  /// blue selection rather than the desk's black one, and payment labels that
  /// wrap instead of shrinking.
  final bool mobile;

  /// A bottom sheet on a phone, where a centred dialog left each payment
  /// button too narrow for its label; a dialog on the desk.
  static Future<HotelCheckOutResult?> show(
    BuildContext context, {
    required double total,
    double advance = 0,
    bool allowCredit = false,
  }) {
    final mobile =
        HotelLayoutScope.maybeMobileOf(context) ??
        HotelLayoutBreakpoints.isHotelMobileLayout(
          MediaQuery.sizeOf(context).width,
        );
    if (mobile) {
      return showModalBottomSheet<HotelCheckOutResult>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        // The sheet's own inset, as in HotelCheckInSheet.show.
        builder: (sheetContext) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: HotelCheckOutDialog(
            total: total,
            mobile: true,
            advance: advance,
            allowCredit: allowCredit,
          ),
        ),
      );
    }
    return showDialog<HotelCheckOutResult>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: HotelCheckOutDialog(
            total: total,
            advance: advance,
            allowCredit: allowCredit,
          ),
        ),
      ),
    );
  }

  @override
  State<HotelCheckOutDialog> createState() => _HotelCheckOutDialogState();
}

class _HotelCheckOutDialogState extends State<HotelCheckOutDialog> {
  /// Wire values: [_paymentType] is handed to the checkout as-is, so only the
  /// label in [_paymentLabel] is localized.
  static const _baseTypes = ['Cash', kMobileMoney, 'DEBIT&CREDIT CARD'];

  /// Credit only when it is offered and there is a balance to owe.
  List<String> get _paymentTypes => [
    ..._baseTypes,
    if (widget.allowCredit && _due > 0) HotelCheckOutDialog.creditTender,
  ];

  String _paymentLabel(FlipperAppLocalizations l10n, String type) {
    switch (type) {
      case 'Cash':
        return l10n.cash;
      case kMobileMoney:
        return l10n.paymentMobileMoney;
      case 'DEBIT&CREDIT CARD':
        return l10n.hotelPaymentCard;
      case HotelCheckOutDialog.creditTender:
        return l10n.hotelPaymentCredit;
      default:
        return type;
    }
  }

  late final TextEditingController _tenderController;
  String _paymentType = 'Cash';

  @override
  void initState() {
    super.initState();
    _tenderController = TextEditingController(text: _due.round().toString());
  }

  @override
  void dispose() {
    _tenderController.dispose();
    super.dispose();
  }

  /// What the guest still owes once the advance is deducted.
  double get _due => HotelAdvanceSettlement.of(
    total: widget.total,
    held: widget.advance,
  ).balance;

  bool get _onCredit => _paymentType == HotelCheckOutDialog.creditTender;

  double get _tender => _paymentType == 'Cash'
      ? (double.tryParse(_tenderController.text.replaceAll(',', '')) ?? 0)
      : _onCredit
      ? 0
      : _due;

  double get _change {
    if (_onCredit) return 0;
    final change = _tender - _due;
    return change < 0 ? 0 : change;
  }

  bool get _canSettle => _onCredit || _tender + 0.5 >= _due;

  /// Shrinks rather than wraps on the desk, where three rails share a
  /// 420-wide dialog. On a phone the label wraps and every rail grows to the
  /// tallest: shrunk to a phone rail, a long translation ("Amafaranga kuri
  /// telefoni") rendered at half size.
  Widget _paymentRails(FlipperAppLocalizations l10n) {
    final rails = Row(
      crossAxisAlignment: widget.mobile
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.center,
      children: [
        for (final type in _paymentTypes) ...[
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _paymentType = type),
              child: Container(
                height: widget.mobile ? null : 44,
                constraints: widget.mobile
                    ? const BoxConstraints(minHeight: 44)
                    : null,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _paymentType == type
                      ? (widget.mobile
                            ? HotelTokens.blueTint
                            : HotelTokens.ink1)
                      : HotelTokens.surface2,
                  borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
                  border: Border.all(
                    color: _paymentType == type
                        ? (widget.mobile ? HotelTokens.blue : HotelTokens.ink1)
                        : HotelTokens.line,
                    width: widget.mobile && _paymentType == type ? 1.5 : 1,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: widget.mobile ? 4 : 0,
                ),
                child: widget.mobile
                    ? _paymentLabelText(l10n, type)
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: _paymentLabelText(l10n, type, maxLines: 1),
                      ),
              ),
            ),
          ),
          if (type != _paymentTypes.last) const SizedBox(width: 8),
        ],
      ],
    );
    return widget.mobile ? IntrinsicHeight(child: rails) : rails;
  }

  Widget _paymentLabelText(
    FlipperAppLocalizations l10n,
    String type, {
    int? maxLines,
  }) => Text(
    _paymentLabel(l10n, type),
    maxLines: maxLines,
    textAlign: TextAlign.center,
    style: GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: _paymentType == type
          ? (widget.mobile ? HotelTokens.blue : Colors.white)
          : HotelTokens.ink2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return SingleChildScrollView(
      child: Container(
        padding: widget.mobile
            ? EdgeInsets.fromLTRB(
                20,
                10,
                20,
                16 + MediaQuery.paddingOf(context).bottom,
              )
            : const EdgeInsets.fromLTRB(22, 20, 22, 22),
        decoration: widget.mobile
            ? hotelPhoneSheetDecoration()
            : const BoxDecoration(
                color: HotelTokens.surface,
                borderRadius: BorderRadius.all(
                  Radius.circular(HotelTokens.mobileSheetRadius),
                ),
              ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.mobile) const HotelSheetHandle(),
            Text(
              l10n.hotelCheckOut,
              style: GoogleFonts.outfit(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: HotelTokens.ink1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              l10n.hotelFolioTotalAmount(hotelMoney(widget.total.round())),
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: HotelTokens.ink3,
              ),
            ),
            if (widget.advance > 0) ...[
              const SizedBox(height: 10),
              HotelAdvanceBalanceRows(
                total: widget.total,
                advance: widget.advance,
              ),
            ],
            const SizedBox(height: 16),
            _paymentRails(l10n),
            if (_paymentType == 'Cash') ...[
              const SizedBox(height: 14),
              TextField(
                controller: _tenderController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: HotelTokens.ink1,
                ),
                decoration: InputDecoration(
                  labelText: l10n.cashReceived,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: HotelTokens.surface2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
                    borderSide: const BorderSide(color: HotelTokens.line),
                  ),
                  // The theme's dark outline read as an error on a phone.
                  enabledBorder: widget.mobile
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            HotelTokens.radiusMd,
                          ),
                          borderSide: const BorderSide(color: HotelTokens.line),
                        )
                      : null,
                  focusedBorder: widget.mobile
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            HotelTokens.radiusMd,
                          ),
                          borderSide: const BorderSide(
                            color: HotelTokens.blue,
                            width: 1.5,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    l10n.hotelChangeDue,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: HotelTokens.ink3,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    hotelMoney(_change.round()),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: HotelTokens.ink1,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        HotelTokens.mobilePrimaryButtonHeight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          HotelTokens.radiusMd,
                        ),
                        side: const BorderSide(
                          color: HotelTokens.line,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: HotelTokens.ink2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Opacity(
                    opacity: _canSettle ? 1 : 0.5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: HotelTokens.gradBtn,
                        borderRadius: BorderRadius.circular(
                          HotelTokens.radiusMd,
                        ),
                      ),
                      child: TextButton(
                        onPressed: _canSettle
                            ? () => Navigator.of(context).pop(
                                HotelCheckOutResult(
                                  paymentType: _paymentType,
                                  cashReceived: _tender,
                                  changeDue: _change,
                                ),
                              )
                            : null,
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(
                            HotelTokens.mobilePrimaryButtonHeight,
                          ),
                        ),
                        child: Text(
                          _onCredit
                              ? l10n.hotelPutOnCredit
                              : l10n.hotelSettleAndRelease,
                          style: GoogleFonts.outfit(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// What the desk chose when a folio reached checkout with no room charge.
enum HotelMissingRoomChargeChoice { post, skip }

/// Shown before payment when the folio bills no room nights.
///
/// Settling it as is records the stay as no sale at all, which is how a sold
/// room ends up missing from the reports. Skipping stays possible — a
/// complimentary night, or an EBM branch whose room has no RRA item yet.
class HotelMissingRoomChargeDialog extends StatelessWidget {
  const HotelMissingRoomChargeDialog({super.key, required this.stay});

  final HotelStay stay;

  static Future<HotelMissingRoomChargeChoice?> show(
    BuildContext context, {
    required HotelStay stay,
  }) {
    return showDialog<HotelMissingRoomChargeChoice>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: HotelMissingRoomChargeDialog(stay: stay),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final amount = stay.nightlyRate * stay.nights;
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      decoration: const BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: BorderRadius.all(
          Radius.circular(HotelTokens.mobileSheetRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.hotelNoRoomChargeTitle,
            style: GoogleFonts.outfit(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: HotelTokens.ink1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.hotelNoRoomChargeBody(
              l10n.hotelNightsCount(stay.nights),
              hotelMoney(stay.nightlyRate.round()),
              hotelMoney(amount.round()),
            ),
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: HotelTokens.ink2,
            ),
          ),
          const SizedBox(height: 18),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: HotelTokens.gradBtn,
              borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
            ),
            child: TextButton(
              key: const ValueKey('hotel-missing-room-charge-post'),
              onPressed: () =>
                  Navigator.of(context).pop(HotelMissingRoomChargeChoice.post),
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(
                  HotelTokens.mobilePrimaryButtonHeight,
                ),
              ),
              child: Text(
                l10n.hotelPostAndContinue,
                style: GoogleFonts.outfit(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      HotelTokens.mobilePrimaryButtonHeight,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
                      side: const BorderSide(
                        color: HotelTokens.line,
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Text(
                    l10n.cancel,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: HotelTokens.ink2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton(
                  key: const ValueKey('hotel-missing-room-charge-skip'),
                  onPressed: () => Navigator.of(
                    context,
                  ).pop(HotelMissingRoomChargeChoice.skip),
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      HotelTokens.mobilePrimaryButtonHeight,
                    ),
                  ),
                  child: Text(
                    l10n.hotelCheckOutWithoutRoomCharge,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: HotelTokens.ink3,
                    ),
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
