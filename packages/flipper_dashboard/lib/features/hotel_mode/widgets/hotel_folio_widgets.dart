import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
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
  });

  final HotelStay stay;
  final bool compact;

  @override
  Widget build(BuildContext context) {
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
                    'Due out',
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
            hotelStaySummary(stay),
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
                  'Arrival',
                  DateFormat('d MMM, HH:mm').format(stay.checkInAt.toLocal()),
                ),
              ),
              Expanded(
                child: _stat(
                  'Departure',
                  DateFormat(
                    'd MMM, HH:mm',
                  ).format(stay.expectedCheckOutAt.toLocal()),
                ),
              ),
              Expanded(child: _stat('Rate', hotelMoney(stay.nightlyRate))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: HotelTokens.ink3,
          ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
        border: Border.all(color: HotelTokens.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: HotelTokens.ink1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${hotelMoney(line.price)} each'
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
            ),
          ),
          if (!readOnly) ...[
            _qtyButton(Icons.remove, onDecrement),
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
            _qtyButton(Icons.add, onIncrement),
            const SizedBox(width: 6),
          ] else ...[
            Text(
              '× ${line.qty.toInt()}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: HotelTokens.ink3,
              ),
            ),
            const SizedBox(width: 12),
          ],
          SizedBox(
            width: 96,
            child: Text(
              hotelMoney(line.price * line.qty),
              textAlign: TextAlign.right,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: HotelTokens.ink1,
              ),
            ),
          ),
          if (!readOnly)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                size: 18,
                color: HotelTokens.ink3,
              ),
            ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: HotelTokens.ink2),
      ),
    );
  }
}

/// Subtotal / VAT / total block.
class HotelFolioTotals extends StatelessWidget {
  const HotelFolioTotals({super.key, required this.lines});

  final List<TransactionItem> lines;

  @override
  Widget build(BuildContext context) {
    // Taken from the lines: a folio mixes 3% tourism tax on room nights with
    // 18% VAT on whatever the bar charged to the room, so one inclusive rate
    // would be wrong for both.
    final breakdown = hotelFolioTaxBreakdown(lines);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HotelTokens.surface2,
        borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
        border: Border.all(color: HotelTokens.line),
      ),
      child: Column(
        children: [
          _row('Subtotal', breakdown.subtotal),
          const SizedBox(height: 6),
          _row('Tax (incl.)', breakdown.tax),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: HotelTokens.line),
          ),
          _row('Folio total', breakdown.total, emphasis: true),
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

/// Payment capture at checkout. Cash requires a tender that covers the folio;
/// the non-cash rails settle at exactly the folio total.
class HotelCheckOutDialog extends StatefulWidget {
  const HotelCheckOutDialog({super.key, required this.total});

  final double total;

  static Future<HotelCheckOutResult?> show(
    BuildContext context, {
    required double total,
  }) {
    return showDialog<HotelCheckOutResult>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: HotelCheckOutDialog(total: total),
        ),
      ),
    );
  }

  @override
  State<HotelCheckOutDialog> createState() => _HotelCheckOutDialogState();
}

class _HotelCheckOutDialogState extends State<HotelCheckOutDialog> {
  static const _paymentTypes = ['Cash', 'Momo', 'Card'];

  late final TextEditingController _tenderController;
  String _paymentType = 'Cash';

  @override
  void initState() {
    super.initState();
    _tenderController = TextEditingController(
      text: widget.total.round().toString(),
    );
  }

  @override
  void dispose() {
    _tenderController.dispose();
    super.dispose();
  }

  double get _tender =>
      _paymentType == 'Cash'
      ? (double.tryParse(_tenderController.text.replaceAll(',', '')) ?? 0)
      : widget.total;

  double get _change {
    final change = _tender - widget.total;
    return change < 0 ? 0 : change;
  }

  bool get _canSettle => _tender + 0.5 >= widget.total;

  @override
  Widget build(BuildContext context) {
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
            'Check out',
            style: GoogleFonts.outfit(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: HotelTokens.ink1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Folio total ${hotelMoney(widget.total.round())}',
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: HotelTokens.ink3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final type in _paymentTypes) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _paymentType = type),
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _paymentType == type
                            ? HotelTokens.ink1
                            : HotelTokens.surface2,
                        borderRadius: BorderRadius.circular(
                          HotelTokens.radiusMd,
                        ),
                        border: Border.all(
                          color: _paymentType == type
                              ? HotelTokens.ink1
                              : HotelTokens.line,
                        ),
                      ),
                      child: Text(
                        type,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _paymentType == type
                              ? Colors.white
                              : HotelTokens.ink2,
                        ),
                      ),
                    ),
                  ),
                ),
                if (type != _paymentTypes.last) const SizedBox(width: 8),
              ],
            ],
          ),
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
                labelText: 'Cash received',
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
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Change due',
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
                      borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
                      side: const BorderSide(
                        color: HotelTokens.line,
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Text(
                    'Cancel',
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
                        'Settle & release room',
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
    );
  }
}
