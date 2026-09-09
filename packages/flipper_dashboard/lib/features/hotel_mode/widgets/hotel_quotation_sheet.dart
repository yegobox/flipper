import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_reservation_sheet.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// Compose a priced offer for a guest.
///
/// The room list is filtered to what is actually sellable for the chosen
/// range, so the desk cannot quote a room it has already sold.
class HotelQuotationSheet extends StatefulWidget {
  const HotelQuotationSheet({
    super.key,
    required this.rooms,
    required this.stays,
    this.existing,
  });

  final List<HotelRoom> rooms;
  final List<HotelStay> stays;
  final HotelQuotation? existing;

  static Future<HotelQuotation?> show(
    BuildContext context, {
    required List<HotelRoom> rooms,
    required List<HotelStay> stays,
    HotelQuotation? existing,
    required bool mobile,
  }) {
    final sheet = HotelQuotationSheet(
      rooms: rooms,
      stays: stays,
      existing: existing,
    );

    if (mobile) {
      return showModalBottomSheet<HotelQuotation>(
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
    return showDialog<HotelQuotation>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 720),
          child: sheet,
        ),
      ),
    );
  }

  @override
  State<HotelQuotationSheet> createState() => _HotelQuotationSheetState();
}

class _HotelQuotationSheetState extends State<HotelQuotationSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _rateController;
  late final TextEditingController _extrasController;
  late final TextEditingController _discountController;

  late DateTime _checkIn;
  late int _nights;
  int _adults = 1;
  int _children = 0;
  int _validForDays = 7;
  HotelRoom? _room;
  String? _error;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;

    _nameController = TextEditingController(text: existing?.guestName ?? '');
    _phoneController = TextEditingController(text: existing?.guestPhone ?? '');
    _rateController = TextEditingController(
      text: (existing?.nightlyRate ?? 0).round().toString(),
    );
    _extrasController = TextEditingController(
      text: (existing?.extrasTotal ?? 0).round().toString(),
    );
    _discountController = TextEditingController(
      text: (existing?.discount ?? 0).round().toString(),
    );

    _checkIn = hotelDateOnly(
      existing?.checkInAt ?? DateTime.now().add(const Duration(days: 1)),
    );
    _nights = existing?.nights ?? 1;
    _adults = existing?.adults ?? 1;
    _children = existing?.children ?? 0;

    if (existing != null) {
      for (final room in widget.rooms) {
        if (room.id == existing.roomId) {
          _room = room;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _rateController.dispose();
    _extrasController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  DateTime get _checkOut => _checkIn.add(Duration(days: _nights));

  double _money(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '')) ?? 0;

  List<HotelRoom> get _sellableRooms => hotelAvailableRooms(
    rooms: widget.rooms,
    stays: widget.stays,
    from: _checkIn,
    to: _checkOut,
    minimumCapacity: _adults + _children,
  );

  double get _total {
    final rate = _money(_rateController);
    final gross = rate * _nights + _money(_extrasController) -
        _money(_discountController);
    return gross < 0 ? 0 : gross;
  }

  Future<void> _pickArrival() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkIn,
      firstDate: hotelDateOnly(DateTime.now()),
      lastDate: hotelDateOnly(DateTime.now()).add(const Duration(days: 730)),
    );
    if (picked == null) return;
    setState(() {
      _checkIn = hotelDateOnly(picked);
      // The chosen room may not survive the new dates.
      if (_room != null && !_sellableRooms.any((r) => r.id == _room!.id)) {
        _room = null;
      }
    });
  }

  void _submit() {
    final name = _nameController.text.trim();
    final room = _room;

    if (name.isEmpty) {
      setState(() => _error = 'Guest name is required');
      return;
    }
    if (room == null) {
      setState(() => _error = 'Pick a room to quote');
      return;
    }

    final phone = _phoneController.text.trim();
    final existing = widget.existing;
    final now = DateTime.now().toUtc();

    Navigator.of(context).pop(
      (existing ??
              HotelQuotation(
                id: const Uuid().v4(),
                branchId: room.branchId,
                reference: newHotelQuotationReference(),
                guestName: name,
                roomId: room.id,
                roomName: room.name,
                roomType: room.roomType,
                checkInAt: _checkIn,
                checkOutAt: _checkOut,
                nightlyRate: 0,
                createdAt: now,
              ))
          .copyWith(
            guestName: name,
            guestPhone: phone.isEmpty ? null : phone,
            roomId: room.id,
            roomName: room.name,
            roomType: room.roomType,
            checkInAt: _checkIn.add(const Duration(hours: 14)),
            checkOutAt: _checkOut.add(const Duration(hours: 11)),
            nightlyRate: _money(_rateController),
            extrasTotal: _money(_extrasController),
            discount: _money(_discountController),
            adults: _adults,
            children: _children,
            validUntil: now.add(Duration(days: _validForDays)),
            updatedAt: now,
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
              widget.existing == null ? 'New quotation' : 'Edit quotation',
              style: GoogleFonts.outfit(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: HotelTokens.ink1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'A priced offer. It holds no room until the guest accepts it.',
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
            _roomPicker(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: HotelSheetField(
                    label: 'Rate / night',
                    controller: _rateController,
                    hint: '0',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HotelSheetField(
                    label: 'Extras',
                    controller: _extrasController,
                    hint: '0',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HotelSheetField(
                    label: 'Discount',
                    controller: _discountController,
                    hint: '0',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            HotelSheetStepper(
              label: 'Valid for (days)',
              value: _validForDays,
              min: 1,
              max: 90,
              onChanged: (v) => setState(() => _validForDays = v),
            ),
            const SizedBox(height: 16),
            _totalRow(),
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
                        widget.existing == null
                            ? 'Save quotation'
                            : 'Update quotation',
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
                  '${DateFormat('EEE d MMM').format(_checkIn)}  →  '
                  '${DateFormat('EEE d MMM').format(_checkOut)}',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
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

  Widget _roomPicker() {
    final rooms = _sellableRooms;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Room · ${rooms.length} available for these dates',
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: HotelTokens.ink3,
          ),
        ),
        const SizedBox(height: 6),
        if (rooms.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: HotelTokens.dirtyTint,
              borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
            ),
            child: Text(
              'Nothing sleeping ${_adults + _children} is free for those dates.',
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: HotelTokens.dirtyInk,
              ),
            ),
          )
        else
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: rooms.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final room = rooms[i];
                final selected = _room?.id == room.id;
                return GestureDetector(
                  onTap: () => setState(() {
                    _room = room;
                    if (_money(_rateController) == 0) {
                      _rateController.text = room.nightlyRate.round().toString();
                    }
                    _error = null;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? HotelTokens.ink1
                          : HotelTokens.surface2,
                      borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
                      border: Border.all(
                        color: selected ? HotelTokens.ink1 : HotelTokens.line,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          room.name,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: selected
                                ? Colors.white
                                : HotelTokens.ink1,
                          ),
                        ),
                        Text(
                          room.roomType,
                          style: GoogleFonts.outfit(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.white70
                                : HotelTokens.ink3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _totalRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: HotelTokens.surface2,
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
        border: Border.all(color: HotelTokens.line),
      ),
      child: Row(
        children: [
          Text(
            '$_nights night${_nights == 1 ? '' : 's'} quoted',
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: HotelTokens.ink3,
            ),
          ),
          const Spacer(),
          Text(
            'RWF ${NumberFormat('#,###').format(_total)}',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: HotelTokens.ink1,
            ),
          ),
        ],
      ),
    );
  }
}
