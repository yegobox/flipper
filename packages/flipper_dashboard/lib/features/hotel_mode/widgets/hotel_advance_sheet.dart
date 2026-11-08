import 'package:flipper_dashboard/features/hotel_mode/hotel_desk_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_folio_widgets.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_shared_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// What the desk entered on the advance sheet.
class HotelAdvanceDraft {
  const HotelAdvanceDraft({required this.amount, required this.paymentMethod});

  final double amount;

  /// Wire value, one of [HotelDeskActions.advanceMethods].
  final String paymentMethod;
}

/// Takes an advance (avance) towards a stay: amount and how it was paid.
///
/// The money is recorded on the day it is paid and deducted at checkout, so
/// the sheet says so — a desk that thinks it is taking a sale would otherwise
/// look for it in the day's sales.
class HotelAdvanceSheet extends StatefulWidget {
  const HotelAdvanceSheet({
    super.key,
    required this.guestName,
    this.mobile = false,
  });

  final String guestName;
  final bool mobile;

  static Future<HotelAdvanceDraft?> show(
    BuildContext context, {
    required String guestName,
  }) {
    final mobile =
        HotelLayoutScope.maybeMobileOf(context) ??
        HotelLayoutBreakpoints.isHotelMobileLayout(
          MediaQuery.sizeOf(context).width,
        );
    if (mobile) {
      return showModalBottomSheet<HotelAdvanceDraft>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: HotelAdvanceSheet(guestName: guestName, mobile: true),
        ),
      );
    }
    return showDialog<HotelAdvanceDraft>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: HotelAdvanceSheet(guestName: guestName),
        ),
      ),
    );
  }

  @override
  State<HotelAdvanceSheet> createState() => _HotelAdvanceSheetState();
}

class _HotelAdvanceSheetState extends State<HotelAdvanceSheet> {
  final _amount = TextEditingController();
  String _method = HotelDeskActions.advanceMethods.first;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  double get _value =>
      double.tryParse(_amount.text.replaceAll(',', '').trim()) ?? 0;

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
              l10n.hotelRecordAdvance,
              style: GoogleFonts.outfit(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: HotelTokens.ink1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              l10n.hotelAdvanceHelp(widget.guestName),
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: HotelTokens.ink3,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const ValueKey('hotel-advance-amount'),
              controller: _amount,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: HotelTokens.ink1,
              ),
              decoration: InputDecoration(
                labelText: l10n.hotelAdvanceAmount,
                isDense: true,
                filled: true,
                fillColor: HotelTokens.surface2,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
                  borderSide: const BorderSide(color: HotelTokens.line),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final method in HotelDeskActions.advanceMethods)
                  ChoiceChip(
                    key: ValueKey('hotel-advance-method-$method'),
                    label: Text(hotelAdvanceMethodLabel(l10n, method)),
                    selected: _method == method,
                    onSelected: (_) => setState(() => _method = method),
                  ),
              ],
            ),
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
                    opacity: _value > 0 ? 1 : 0.5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: HotelTokens.gradBtn,
                        borderRadius: BorderRadius.circular(
                          HotelTokens.radiusMd,
                        ),
                      ),
                      child: TextButton(
                        key: const ValueKey('hotel-advance-save'),
                        onPressed: _value > 0
                            ? () => Navigator.of(context).pop(
                                HotelAdvanceDraft(
                                  amount: _value,
                                  paymentMethod: _method,
                                ),
                              )
                            : null,
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(
                            HotelTokens.mobilePrimaryButtonHeight,
                          ),
                        ),
                        child: Text(
                          _value > 0
                              ? l10n.hotelRecordAdvanceAmount(
                                  hotelMoney(_value.round()),
                                )
                              : l10n.hotelRecordAdvance,
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
