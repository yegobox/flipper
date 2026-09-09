import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// What the desk filled in on the check-in form.
class HotelCheckInDraft {
  const HotelCheckInDraft({
    required this.guestName,
    required this.guestPhone,
    required this.adults,
    required this.children,
    required this.nights,
    required this.nightlyRate,
    required this.checkInAt,
    required this.expectedCheckOutAt,
  });

  final String guestName;
  final String? guestPhone;
  final int adults;
  final int children;
  final int nights;
  final double nightlyRate;
  final DateTime checkInAt;
  final DateTime expectedCheckOutAt;

  double get roomTotal => nightlyRate * nights;
}

/// Check-in form. Presented as a dialog on desktop and a sheet on mobile —
/// one widget so the two layouts can never validate differently.
class HotelCheckInSheet extends StatefulWidget {
  const HotelCheckInSheet({super.key, required this.room});

  final HotelRoom room;

  /// Returns the draft, or null when the desk backs out.
  static Future<HotelCheckInDraft?> show(
    BuildContext context, {
    required HotelRoom room,
    required bool mobile,
  }) {
    if (mobile) {
      return showModalBottomSheet<HotelCheckInDraft>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        // Read from the sheet's own context, and only the inset: the caller's
        // context keeps the pre-keyboard value, leaving the fields covered.
        builder: (sheetContext) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: HotelCheckInSheet(room: room),
        ),
      );
    }
    return showDialog<HotelCheckInDraft>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: HotelCheckInSheet(room: room),
        ),
      ),
    );
  }

  @override
  State<HotelCheckInSheet> createState() => _HotelCheckInSheetState();
}

class _HotelCheckInSheetState extends State<HotelCheckInSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late final TextEditingController _rateController;

  int _nights = 1;
  int _adults = 1;
  int _children = 0;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _rateController = TextEditingController(
      text: widget.room.nightlyRate.round().toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  double get _rate =>
      double.tryParse(_rateController.text.replaceAll(',', '')) ??
      widget.room.nightlyRate;

  DateTime get _checkOut => hotelDefaultCheckOut(
    checkIn: DateTime.now(),
    nights: _nights,
    checkOutHour: HotelModeSettings.checkOutHour,
  );

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Guest name is required');
      return;
    }
    if (_adults + _children > widget.room.capacity) {
      setState(
        () => _nameError =
            'Room ${widget.room.name} sleeps ${widget.room.capacity}',
      );
      return;
    }

    final now = DateTime.now();
    final phone = _phoneController.text.trim();
    Navigator.of(context).pop(
      HotelCheckInDraft(
        guestName: name,
        guestPhone: phone.isEmpty ? null : phone,
        adults: _adults,
        children: _children,
        nights: _nights,
        nightlyRate: _rate,
        checkInAt: now,
        expectedCheckOutAt: _checkOut,
      ),
    );
  }

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
            'Check in · Room ${widget.room.name}',
            style: GoogleFonts.outfit(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: HotelTokens.ink1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${widget.room.roomType} · sleeps ${widget.room.capacity}',
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: HotelTokens.ink3,
            ),
          ),
          const SizedBox(height: 18),
          _field(
            label: 'Guest name',
            controller: _nameController,
            hint: 'e.g. Aline Uwase',
            errorText: _nameError,
            onChanged: (_) {
              if (_nameError != null) setState(() => _nameError = null);
            },
          ),
          const SizedBox(height: 12),
          _field(
            label: 'Phone (optional)',
            controller: _phoneController,
            hint: '07…',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _stepper('Nights', _nights, 1, 60, (v) {
                  setState(() => _nights = v);
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _stepper('Adults', _adults, 1, 10, (v) {
                  setState(() => _adults = v);
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _stepper('Children', _children, 0, 10, (v) {
                  setState(() => _children = v);
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _field(
            label: 'Rate per night (RWF)',
            controller: _rateController,
            hint: '0',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          _summaryRow(),
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
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: HotelTokens.gradBtn,
                    borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
                  ),
                  child: TextButton(
                    onPressed: _submit,
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        HotelTokens.mobilePrimaryButtonHeight,
                      ),
                    ),
                    child: Text(
                      'Check in guest',
                      style: GoogleFonts.outfit(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
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

  Widget _summaryRow() {
    final total = _rate * _nights;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: HotelTokens.surface2,
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
                  'Departure',
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: HotelTokens.ink3,
                  ),
                ),
                Text(
                  DateFormat('EEE d MMM, HH:mm').format(_checkOut),
                  style: GoogleFonts.outfit(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: HotelTokens.ink1,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Room charge',
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: HotelTokens.ink3,
                ),
              ),
              Text(
                'RWF ${NumberFormat('#,###').format(total)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: HotelTokens.ink1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? errorText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: HotelTokens.ink3,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: HotelTokens.ink1,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            filled: true,
            fillColor: HotelTokens.surface2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
              borderSide: const BorderSide(color: HotelTokens.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
              borderSide: const BorderSide(color: HotelTokens.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
              borderSide: const BorderSide(color: HotelTokens.blue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepper(
    String label,
    int value,
    int min,
    int max,
    ValueChanged<int> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: HotelTokens.ink3,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: HotelTokens.surface2,
            borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
            border: Border.all(color: HotelTokens.line),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stepButton(
                Icons.remove,
                value > min ? () => onChanged(value - 1) : null,
              ),
              Text(
                '$value',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HotelTokens.ink1,
                ),
              ),
              _stepButton(
                Icons.add,
                value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepButton(IconData icon, VoidCallback? onTap) {
    return SizedBox(
      width: 34,
      height: 44,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        icon: Icon(
          icon,
          size: 17,
          color: onTap == null ? HotelTokens.ink4 : HotelTokens.ink2,
        ),
      ),
    );
  }
}
