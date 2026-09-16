import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_desk_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/services/hotel_quotation_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_desk_nav.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_quotation_sheet.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_reservation_sheet.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// Quotations: priced offers the desk sends, and turns into reservations.
class HotelQuotationsScreen extends ConsumerWidget {
  const HotelQuotationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotes = ref.watch(hotelSortedQuotationsProvider);
    final quotesAsync = ref.watch(hotelQuotationsProvider);
    final rooms = ref.watch(hotelRoomsProvider).value ?? const <HotelRoom>[];
    final stays = ref.watch(hotelStaysProvider).value ?? const <HotelStay>[];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = HotelLayoutBreakpoints.isHotelMobileLayout(
          constraints.maxWidth,
        );
        final pad = compact ? 16.0 : 30.0;

        return Container(
          color: HotelTokens.posBg,
          child: Column(
            children: [
              _header(context, ref, rooms, stays, quotes, compact),
              Expanded(
                child: quotesAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
                  data: (_) => quotes.isEmpty
                      ? _empty()
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(pad, pad, pad, pad + 12),
                          itemCount: quotes.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) => _quoteCard(
                            context,
                            ref,
                            quotes[i],
                            rooms,
                            stays,
                            compact,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(
    BuildContext context,
    WidgetRef ref,
    List<HotelRoom> rooms,
    List<HotelStay> stays,
    List<HotelQuotation> quotes,
    bool compact,
  ) {
    final live = quotes.where(hotelQuotationCanConvert).length;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 14 : 30,
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        color: HotelTokens.surface,
        border: Border(bottom: BorderSide(color: HotelTokens.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HotelDeskNav(compact: compact),
              const Spacer(),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: HotelTokens.gradBtn,
                  borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
                ),
                child: TextButton.icon(
                  onPressed: () => _newQuote(context, ref, rooms, stays, compact),
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: Text(
                    compact ? 'New' : 'New quotation',
                    style: GoogleFonts.outfit(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Quotations',
            style: GoogleFonts.outfit(
              fontSize: compact ? 16 : 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: HotelTokens.ink1,
            ),
          ),
          Text(
            '$live open · a quotation holds no room until it is accepted',
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
    );
  }

  Widget _empty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Text(
          'No quotations yet.\nCreate one to price a stay for a guest before '
          'they commit.',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: HotelTokens.ink3,
          ),
        ),
      ),
    );
  }

  Widget _quoteCard(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
    List<HotelRoom> rooms,
    List<HotelStay> stays,
    bool compact,
  ) {
    final canConvert = hotelQuotationCanConvert(quote);
    final label = hotelQuotationStatusLabel(quote);
    final (ink, tint) = switch (label) {
      'Booked' => (HotelTokens.vacantInk, HotelTokens.vacantTint),
      'Expired' => (HotelTokens.blockedInk, HotelTokens.blockedTint),
      'Declined' => (HotelTokens.lossInk, HotelTokens.dirtyTint),
      'Accepted' => (HotelTokens.reservedInk, HotelTokens.reservedTint),
      _ => (HotelTokens.occupiedInk, HotelTokens.occupiedTint),
    };
    final statusIcon = switch (label) {
      'Booked' || 'Accepted' => AdminDashboardSvgs.quoteCheckCircle,
      'Expired' => AdminDashboardSvgs.quoteClock,
      'Declined' => AdminDashboardSvgs.quoteRemoveCircle,
      _ => AdminDashboardSvgs.quoteDraft,
    };

    return Container(
      padding: const EdgeInsets.all(16),
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
              Flexible(
                child: Text(
                  quote.guestName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: HotelTokens.ink1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                quote.reference,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: HotelTokens.ink4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Wrap, not Row: on a narrow desk terminal these three facts should
          // stack rather than ellipsize away the night count.
          Wrap(
            spacing: 16,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _metaChip(
                AdminDashboardSvgs.quoteBed,
                'Room ${quote.roomName} · ${quote.roomType}',
              ),
              _metaChip(
                AdminDashboardSvgs.quoteCalendar,
                '${DateFormat('d MMM').format(quote.checkInAt.toLocal())} → '
                '${DateFormat('d MMM').format(quote.checkOutAt.toLocal())}',
              ),
              _metaChip(
                AdminDashboardSvgs.quoteMoon,
                '${quote.nights} night${quote.nights == 1 ? '' : 's'}',
              ),
            ],
          ),
          if (quote.sentAt != null) ...[
            const SizedBox(height: 6),
            _metaChip(
              AdminDashboardSvgs.quoteSend,
              'Emailed ${DateFormat('d MMM, HH:mm').format(quote.sentAt!.toLocal())}'
              '${quote.guestEmail == null ? '' : ' · ${quote.guestEmail}'}',
              color: HotelTokens.vacantInk,
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'RWF ${NumberFormat('#,###').format(quote.total)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: HotelTokens.ink1,
                ),
              ),
              if (quote.validUntil != null && canConvert)
                _metaChip(
                  AdminDashboardSvgs.quoteClock,
                  'valid to '
                  '${DateFormat('d MMM').format(quote.validUntil!.toLocal())}',
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statusPill(icon: statusIcon, label: label, ink: ink, tint: tint),
              const SizedBox(width: 8),
              // Actions stay right-aligned; the Wrap inside the Expanded lets a
              // narrow terminal drop them onto a second line rather than
              // overflowing, without giving up the alignment.
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _documentButton(context, ref, quote),
                    if (canConvert) ...[
                      _iconTextButton(
                        icon: AdminDashboardSvgs.quoteEdit,
                        label: 'Edit',
                        color: HotelTokens.ink2,
                        onPressed: () => _editQuote(
                          context,
                          ref,
                          quote,
                          rooms,
                          stays,
                          compact,
                        ),
                      ),
                      _acceptButton(context, ref, quote, rooms),
                    ] else
                      _iconTextButton(
                        icon: AdminDashboardSvgs.quoteTrash,
                        label: 'Remove',
                        color: HotelTokens.lossInk,
                        onPressed: () => _confirmDelete(context, ref, quote),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// One icon + label fact from the quotation, e.g. the room or the dates.
  Widget _metaChip(String icon, String text, {Color? color}) {
    final tone = color ?? HotelTokens.ink3;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AdminDashboardSvgs.tinted(icon, color: tone, size: 15),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: tone,
          ),
        ),
      ],
    );
  }

  Widget _statusPill({
    required String icon,
    required String label,
    required Color ink,
    required Color tint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdminDashboardSvgs.tinted(icon, color: ink, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconTextButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    String? trailingIcon,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdminDashboardSvgs.tinted(icon, color: color, size: 17),
          const SizedBox(width: 7),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 5),
            AdminDashboardSvgs.tinted(trailingIcon, color: color, size: 15),
          ],
        ],
      ),
    );
  }


  /// Send / Download / Print.
  ///
  /// Deliberately `showMenu` rather than [PopupMenuButton]: that widget always
  /// wraps its child in a [Tooltip], and a Tooltip under DevicePreview's
  /// LayoutBuilder trips `!_skipMarkNeedsLayout` in this app.
  Widget _documentButton(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
  ) {
    // The Builder matters: without it the context here is the ListView's
    // itemBuilder context, whose nearest render object is the RenderSliverList
    // — not a RenderBox — so anchoring the menu to it fails. The Builder sits
    // inside the button, so its context resolves to the button's own box.
    return Builder(
      builder: (buttonContext) => _iconTextButton(
        icon: AdminDashboardSvgs.quoteDocument,
        label: 'Document',
        color: HotelTokens.ink2,
        trailingIcon: AdminDashboardSvgs.quoteChevronDown,
        onPressed: () => _showDocumentMenu(buttonContext, ref, quote),
      ),
    );
  }

  /// Anchors the menu just below [context]'s widget.
  ///
  /// Returns null rather than throwing when the render tree is not what we
  /// expect; the caller then falls back to a usable position, because a menu
  /// in the wrong corner beats a button that does nothing.
  static RelativeRect? _menuPosition(BuildContext context) {
    final box = context.findRenderObject();
    final overlay = Overlay.of(context).context.findRenderObject();
    if (box is! RenderBox || overlay is! RenderBox) return null;
    if (!box.hasSize || !overlay.hasSize) return null;

    final origin = box.localToGlobal(Offset.zero, ancestor: overlay);
    return RelativeRect.fromLTRB(
      origin.dx,
      origin.dy + box.size.height,
      overlay.size.width - origin.dx - box.size.width,
      0,
    );
  }

  Future<void> _showDocumentMenu(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
  ) async {
    final choice = await showMenu<String>(
      context: context,
      position: _menuPosition(context) ?? const RelativeRect.fromLTRB(0, 0, 0, 0),
      items: [
        _menuItem(
          value: 'send',
          icon: AdminDashboardSvgs.quoteSend,
          label: quote.guestEmail == null
              ? 'Send to guest…'
              : 'Send to ${quote.guestEmail}',
        ),
        _menuItem(
          value: 'download',
          icon: AdminDashboardSvgs.quoteDownload,
          label: 'Download PDF',
        ),
        _menuItem(
          value: 'print',
          icon: AdminDashboardSvgs.quotePrint,
          label: 'Print',
        ),
      ],
    );
    if (choice == null || !context.mounted) return;

    // No try/catch around the document actions: the shared presenter already
    // reports its own failures through the same progress/snackbar surface the
    // sale receipt uses, and a toast on top would say it twice.
    switch (choice) {
      case 'send':
        await _sendQuote(context, ref, quote);
      case 'download':
        await HotelQuotationActions.download(context, quote);
      case 'print':
        await HotelQuotationActions.print(context, quote);
    }
  }

  PopupMenuItem<String> _menuItem({
    required String value,
    required String icon,
    required String label,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdminDashboardSvgs.tinted(icon, color: HotelTokens.ink2, size: 18),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: HotelTokens.ink1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendQuote(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
  ) async {
    var target = quote;

    if (target.guestEmail == null) {
      final entered = await _askForEmail(context, target);
      if (entered == null || !context.mounted) return;
      // Persist the address first, so a failed send does not lose what the
      // clerk just typed and a retry has something to send to.
      target = target.copyWith(
        guestEmail: entered,
        updatedAt: DateTime.now().toUtc(),
      );
      await HotelDeskActions.saveQuotation(target);
    }

    if (!context.mounted) return;
    await HotelDeskActions.sendQuotation(ref: ref, quotation: target);
  }

  /// Collects the guest's email when a quotation has none.
  ///
  /// Shows what is about to be sent — reference, room, total — because this is
  /// the last stop before a document leaves the property, and a clerk typing
  /// an address should be able to see they picked the right quotation.
  Future<String?> _askForEmail(
    BuildContext context,
    HotelQuotation quote,
  ) async {
    final controller = TextEditingController();
    try {
      return await showDialog<String>(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.42),
        builder: (dialogContext) {
          String? error;
          return StatefulBuilder(
            builder: (builderContext, setLocalState) {
              void submit() {
                final value = hotelNormalizeEmail(controller.text);
                if (value == null || !hotelIsPlausibleEmail(value)) {
                  setLocalState(
                    () => error = 'That email does not look right',
                  );
                  return;
                }
                Navigator.of(dialogContext).pop(value);
              }

              return Dialog(
                backgroundColor: HotelTokens.surface,
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(HotelTokens.radiusXl),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: HotelTokens.blueTint,
                                borderRadius: BorderRadius.circular(
                                  HotelTokens.radiusMd,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: AdminDashboardSvgs.tinted(
                                AdminDashboardSvgs.quoteSend,
                                color: HotelTokens.blue,
                                size: 21,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email this quotation',
                                    style: GoogleFonts.outfit(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.2,
                                      color: HotelTokens.ink1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'The PDF goes out as an attachment.',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w500,
                                      color: HotelTokens.ink3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      // A summary of what is about to be sent, so the clerk can
                      // confirm they are on the right card before typing.
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: HotelTokens.posBg,
                          borderRadius: BorderRadius.circular(
                            HotelTokens.radiusMd,
                          ),
                          border: Border.all(color: HotelTokens.line),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    quote.guestName,
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
                                    'Room ${quote.roomName} · '
                                    '${quote.nights} night'
                                    '${quote.nights == 1 ? '' : 's'}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: HotelTokens.ink3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  quote.reference,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: HotelTokens.ink4,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'RWF '
                                  '${NumberFormat('#,###').format(quote.total)}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: HotelTokens.ink1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: HotelSheetField(
                          label: 'Guest email',
                          controller: controller,
                          hint: 'name@example.com',
                          errorText: error,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) {
                            if (error != null) {
                              setLocalState(() => error = null);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Saved to the quotation, so the next send needs no '
                          'retyping.',
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: HotelTokens.ink4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(dialogContext).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.outfit(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: HotelTokens.ink3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: HotelTokens.gradBtn,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: TextButton(
                                onPressed: submit,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AdminDashboardSvgs.tinted(
                                      AdminDashboardSvgs.quoteSend,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Send quotation',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } finally {
      controller.dispose();
    }
  }

  Widget _acceptButton(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
    List<HotelRoom> rooms,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: HotelTokens.gradBtn,
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
      ),
      child: TextButton(
        onPressed: () => _accept(context, ref, quote, rooms),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdminDashboardSvgs.tinted(
              AdminDashboardSvgs.quoteCheck,
              color: Colors.white,
              size: 17,
            ),
            const SizedBox(width: 7),
            Text(
              'Accept & hold',
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _newQuote(
    BuildContext context,
    WidgetRef ref,
    List<HotelRoom> rooms,
    List<HotelStay> stays,
    bool compact,
  ) async {
    final quote = await HotelQuotationSheet.show(
      context,
      rooms: rooms,
      stays: stays,
      mobile: compact,
    );
    if (quote == null) return;
    await HotelDeskActions.saveQuotation(quote);
  }

  Future<void> _editQuote(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
    List<HotelRoom> rooms,
    List<HotelStay> stays,
    bool compact,
  ) async {
    final updated = await HotelQuotationSheet.show(
      context,
      rooms: rooms,
      stays: stays,
      existing: quote,
      mobile: compact,
    );
    if (updated == null) return;
    await HotelDeskActions.saveQuotation(updated);
  }

  Future<void> _accept(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
    List<HotelRoom> rooms,
  ) async {
    final clerk = ref.read(hotelModeProvider).activeClerk;
    if (clerk == null) return;

    HotelRoom? room;
    for (final candidate in rooms) {
      if (candidate.id == quote.roomId) {
        room = candidate;
        break;
      }
    }
    if (room == null) {
      ref
          .read(hotelModeProvider.notifier)
          .showToast('Room ${quote.roomName} no longer exists on this branch');
      return;
    }

    await HotelDeskActions.convertQuotation(
      ref: ref,
      quotation: quote,
      room: room,
      clerk: clerk,
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Remove ${quote.reference}?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This deletes the quotation for ${quote.guestName}. Any reservation '
          'it already created is untouched.',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await HotelDeskActions.deleteQuotation(id: quote.id);
  }
}
