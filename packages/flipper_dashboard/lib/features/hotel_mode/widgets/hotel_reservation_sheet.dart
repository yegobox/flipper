import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// A future booking the desk is about to commit.
class HotelReservationDraft {
  const HotelReservationDraft({
    required this.guestName,
    required this.guestPhone,
    required this.adults,
    required this.children,
    required this.checkInAt,
    required this.checkOutAt,
    required this.nightlyRate,
    required this.note,
  });

  final String guestName;
  final String? guestPhone;
  final int adults;
  final int children;
  final DateTime checkInAt;
  final DateTime checkOutAt;
  final double nightlyRate;
  final String? note;

  int get nights => hotelNightsBetween(checkInAt, checkOutAt);
  double get roomTotal => nightlyRate * nights;
}

/// Holds a room for a future arrival.
///
/// Separate from the check-in sheet on purpose: a reservation is a date range
/// the guest has not arrived for, so arrival is a chosen date rather than now.
class HotelReservationSheet extends StatefulWidget {
  const HotelReservationSheet({
    super.key,
    required this.room,
    required this.initialCheckIn,
    this.clashingStays = const [],
  });

  final HotelRoom room;
  final DateTime initialCheckIn;

  /// Open stays for this room, used to warn before the write is attempted.
  final List<HotelStay> clashingStays;

  static Future<HotelReservationDraft?> show(
    BuildContext context, {
    required HotelRoom room,
    required DateTime initialCheckIn,
    List<HotelStay> clashingStays = const [],
    required bool mobile,
  }) {
    final sheet = HotelReservationSheet(
      room: room,
      initialCheckIn: initialCheckIn,
      clashingStays: clashingStays,
    );

    if (mobile) {
      return showModalBottomSheet<HotelReservationDraft>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: sheet,
        ),
      );
    }
    return showDialog<HotelReservationDraft>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 470),
          child: sheet,
        ),
      ),
    );
  }

  @override
  State<HotelReservationSheet> createState() => _HotelReservationSheetState();
}

class _HotelReservationSheetState extends State<HotelReservationSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late final TextEditingController _rateController;

  late DateTime _checkIn;
  int _nights = 1;
  int _adults = 1;
  int _children = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkIn = hotelDateOnly(widget.initialCheckIn);
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

  DateTime get _checkOut => _checkIn.add(Duration(days: _nights));

  double get _rate =>
      double.tryParse(_rateController.text.replaceAll(',', '')) ??
      widget.room.nightlyRate;

  bool get _clashes => !hotelRoomAvailableForRange(
    room: widget.room,
    stays: widget.clashingStays,
    from: _checkIn,
    to: _checkOut,
  );

  Future<void> _pickArrival() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkIn,
      firstDate: hotelDateOnly(DateTime.now()),
      lastDate: hotelDateOnly(DateTime.now()).add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _checkIn = hotelDateOnly(picked));
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Guest name is required');
      return;
    }
    if (_adults + _children > widget.room.capacity) {
      setState(
        () => _error = 'Room ${widget.room.name} sleeps ${widget.room.capacity}',
      );
      return;
    }
    if (_clashes) {
      setState(() => _error = 'Those dates are already taken for this room');
      return;
    }

    final phone = _phoneController.text.trim();
    Navigator.of(context).pop(
      HotelReservationDraft(
        guestName: name,
        guestPhone: phone.isEmpty ? null : phone,
        adults: _adults,
        children: _children,
        checkInAt: _checkIn.add(const Duration(hours: 14)),
        checkOutAt: _checkOut.add(const Duration(hours: 11)),
        nightlyRate: _rate,
        note: null,
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reserve · Room ${widget.room.name}',
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
            HotelSheetField(
              label: 'Guest name',
              controller: _nameController,
              hint: 'e.g. Aline Uwase',
              errorText: _error,
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            const SizedBox(height: 12),
            HotelSheetField(
              label: 'Phone (optional)',
              controller: _phoneController,
              hint: '07…',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _arrivalRow(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: HotelSheetStepper(
                    label: 'Nights',
                    value: _nights,
                    min: 1,
                    max: 60,
                    onChanged: (v) => setState(() => _nights = v),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HotelSheetStepper(
                    label: 'Adults',
                    value: _adults,
                    min: 1,
                    max: 10,
                    onChanged: (v) => setState(() => _adults = v),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HotelSheetStepper(
                    label: 'Children',
                    value: _children,
                    min: 0,
                    max: 10,
                    onChanged: (v) => setState(() => _children = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            HotelSheetField(
              label: 'Rate per night (RWF)',
              controller: _rateController,
              hint: '0',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (_clashes) _clashNotice() else _summary(),
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
                    opacity: _clashes ? 0.5 : 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: HotelTokens.gradBtn,
                        borderRadius: BorderRadius.circular(
                          HotelTokens.radiusMd,
                        ),
                      ),
                      child: TextButton(
                        onPressed: _clashes ? null : _submit,
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(
                            HotelTokens.mobilePrimaryButtonHeight,
                          ),
                        ),
                        child: Text(
                          'Hold the room',
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

  Widget _arrivalRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Arrival',
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: HotelTokens.ink3,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pickArrival,
          borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: HotelTokens.surface2,
              borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
              border: Border.all(color: HotelTokens.line),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 17,
                  color: HotelTokens.ink3,
                ),
                const SizedBox(width: 10),
                Text(
                  DateFormat('EEE d MMM yyyy').format(_checkIn),
                  style: GoogleFonts.outfit(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: HotelTokens.ink1,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.expand_more,
                  size: 18,
                  color: HotelTokens.ink3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _summary() {
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
                  DateFormat('EEE d MMM').format(_checkOut),
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
                '$_nights night${_nights == 1 ? '' : 's'}',
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: HotelTokens.ink3,
                ),
              ),
              Text(
                'RWF ${NumberFormat('#,###').format(_rate * _nights)}',
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

  Widget _clashNotice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: HotelTokens.dirtyTint,
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.event_busy_outlined,
            size: 18,
            color: HotelTokens.dirtyInk,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Room ${widget.room.name} is already taken between '
              '${DateFormat('d MMM').format(_checkIn)} and '
              '${DateFormat('d MMM').format(_checkOut)}.',
              style: GoogleFonts.outfit(
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: HotelTokens.dirtyInk,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Labelled text field in the hotel sheet style.
class HotelSheetField extends StatelessWidget {
  const HotelSheetField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.errorText,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
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
}

/// Labelled -/+ stepper in the hotel sheet style.
class HotelSheetStepper extends StatelessWidget {
  const HotelSheetStepper({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
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
              _button(Icons.remove, value > min ? () => onChanged(value - 1) : null),
              Text(
                '$value',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HotelTokens.ink1,
                ),
              ),
              _button(Icons.add, value < max ? () => onChanged(value + 1) : null),
            ],
          ),
        ),
      ],
    );
  }

  Widget _button(IconData icon, VoidCallback? onTap) {
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
