import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// Picks the in-house guest a tab from another outlet is charged to.
///
/// Lives in Hotel Mode rather than Bar Mode because the bar is only the first
/// caller: the restaurant, the shop and the spa all post to the same folio,
/// and they must all show the desk the same list of guests.
class HotelStayPicker extends ConsumerStatefulWidget {
  const HotelStayPicker({super.key, this.title, this.subtitle});

  final String? title;
  final String? subtitle;

  /// Returns the chosen stay, or null when the operator backs out.
  static Future<HotelStay?> show(
    BuildContext context, {
    required bool mobile,
    String? title,
    String? subtitle,
  }) {
    if (mobile) {
      return showModalBottomSheet<HotelStay>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        // Read the inset from the sheet's own context: the caller's copy still
        // holds the pre-keyboard value, which would leave the search field
        // under the keyboard.
        builder: (sheetContext) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: HotelStayPicker(title: title, subtitle: subtitle),
        ),
      );
    }
    return showDialog<HotelStay>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460, maxHeight: 560),
          child: HotelStayPicker(title: title, subtitle: subtitle),
        ),
      ),
    );
  }

  @override
  ConsumerState<HotelStayPicker> createState() => _HotelStayPickerState();
}

class _HotelStayPickerState extends ConsumerState<HotelStayPicker> {
  final _searchController = TextEditingController();
  String _term = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(hotelStaysLoadingProvider);
    final all = ref.watch(hotelChargeableStaysProvider);
    final matches = all
        .where((stay) => hotelStayMatchesSearch(stay, _term))
        .toList();

    return Material(
      color: HotelTokens.surface,
      borderRadius: BorderRadius.circular(HotelTokens.radiusXl),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(context),
            const SizedBox(height: 14),
            if (all.isNotEmpty) ...[_searchField(), const SizedBox(height: 12)],
            Flexible(
              child: all.isEmpty
                  ? _emptyState(loading: loading)
                  : matches.isEmpty
                  ? _noMatches()
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: matches.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, index) => _stayRow(matches[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title ?? 'Charge to room',
                style: GoogleFonts.outfit(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: HotelTokens.ink1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.subtitle ??
                    'Pick the guest whose folio picks up this bill.',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                  color: HotelTokens.ink3,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, size: 20),
          color: HotelTokens.ink3,
          tooltip: 'Close',
        ),
      ],
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      onChanged: (value) => setState(() => _term = value),
      style: GoogleFonts.outfit(fontSize: 14.5, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Room number, guest name or phone',
        hintStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: HotelTokens.ink4,
        ),
        prefixIcon: const Icon(Icons.search, size: 19),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
    );
  }

  Widget _stayRow(HotelStay stay) {
    final out = DateFormat('EEE d MMM').format(stay.expectedCheckOutAt);
    return Material(
      color: HotelTokens.surface,
      borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(stay),
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
            border: Border.all(color: HotelTokens.line),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: HotelTokens.occupiedTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  stay.roomName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: HotelTokens.occupiedInk,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stay.guestName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: HotelTokens.ink1,
                      ),
                    ),
                    Text(
                      '${hotelStaySummary(stay)} · out $out',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: HotelTokens.ink3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: HotelTokens.ink4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState({required bool loading}) {
    return _notice(
      icon: loading ? Icons.hourglass_empty : Icons.hotel_outlined,
      title: loading ? 'Looking up guests…' : 'Nobody is checked in',
      body: loading
          ? 'Reading the rooms from this branch.'
          : 'A tab can only be charged to a guest who has checked in. '
                'Reservations pick up charges once they arrive.',
    );
  }

  Widget _noMatches() {
    return _notice(
      icon: Icons.search_off,
      title: 'No guest matches "${_term.trim()}"',
      body: 'Search by room number, guest name or phone.',
    );
  }

  Widget _notice({
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: HotelTokens.ink4),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: HotelTokens.ink2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: HotelTokens.ink3,
            ),
          ),
        ],
      ),
    );
  }
}
