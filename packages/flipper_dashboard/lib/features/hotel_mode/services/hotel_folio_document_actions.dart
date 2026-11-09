import 'dart:typed_data';

import 'package:flipper_dashboard/features/hotel_mode/hotel_folio_pdf.dart';
import 'package:flipper_dashboard/features/hotel_mode/services/hotel_quotation_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/services/pdf_presentation_service.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Print / download / share a guest's folio: the pro-forma bill while the
/// guest is in, the invoice once they have left.
///
/// Built from the store at the moment of printing, never from what a screen
/// last showed, so a reprint days later still lists every night and extra.
abstract final class HotelFolioDocumentActions {
  static DatabaseSyncInterface get _sync =>
      ProxyService.getStrategy(Strategy.capella);

  static Future<Uint8List> buildPdf(HotelStay stay) async {
    final hasFolio = stay.hasFolio;
    final (folio, lines, issuer, stamp) = await (
      hasFolio
          ? _sync.hotelFolio(transactionId: stay.transactionId)
          : Future.value(null),
      hasFolio
          ? _sync.hotelFolioLines(transactionId: stay.transactionId)
          : Future.value(const <Never>[]),
      HotelQuotationActions.documentIssuer(stay.branchId),
      HotelQuotationActions.documentStamp(),
    ).wait;
    if (hotelFolioStillSyncing(stay: stay, folio: folio, lines: lines)) {
      throw StateError(FlipperL10n.current.hotelFolioStillSyncing);
    }
    return HotelFolioPdf.build(
      stay: stay,
      lines: lines,
      folio: folio,
      currency: HotelQuotationActions.documentCurrency,
      issuer: issuer,
      stamp: stamp,
    );
  }

  static String fileName(HotelStay stay) {
    final safeRoom = stay.roomName.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '-');
    final day = stay.checkInAt.toLocal();
    return 'folio-room-$safeRoom-'
        '${day.year}${day.month.toString().padLeft(2, '0')}'
        '${day.day.toString().padLeft(2, '0')}.pdf';
  }

  static Future<void> present(
    BuildContext context,
    HotelStay stay,
    PdfPresentationMode mode,
  ) {
    final l10n = context.flipperL10n;
    return HotelQuotationActions.presenter.present(
      context,
      mode: mode,
      progressMessage: l10n.hotelPreparingFolio,
      build: () => buildPdf(stay),
      filename: () => fileName(stay),
      label: l10n.hotelFolioDocument,
      shareSubject: l10n.hotelFolioShareSubject(stay.roomName, stay.guestName),
    );
  }
}

/// "Print" on the folio and the checked-out list, opening Print / Download /
/// Share.
///
/// `showMenu` rather than [PopupMenuButton], and no tooltip: both wrap a
/// [Tooltip], which trips a layout assert under DevicePreview in this app.
class HotelFolioDocumentMenu extends StatelessWidget {
  const HotelFolioDocumentMenu({super.key, required this.stay});

  final HotelStay stay;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Builder(
      builder: (buttonContext) => TextButton.icon(
        key: const ValueKey('hotel-folio-print'),
        onPressed: () => _open(buttonContext),
        icon: const Icon(Icons.print_outlined, size: 18),
        label: Text(
          l10n.hotelQuotePrint,
          style: GoogleFonts.outfit(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final l10n = context.flipperL10n;
    final box = context.findRenderObject();
    final overlay = Overlay.of(context).context.findRenderObject();
    var position = const RelativeRect.fromLTRB(0, 0, 0, 0);
    if (box is RenderBox && overlay is RenderBox && box.hasSize) {
      final origin = box.localToGlobal(Offset.zero, ancestor: overlay);
      position = RelativeRect.fromLTRB(
        origin.dx,
        origin.dy + box.size.height,
        overlay.size.width - origin.dx - box.size.width,
        0,
      );
    }
    final choice = await showMenu<PdfPresentationMode>(
      context: context,
      position: position,
      color: HotelTokens.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
        side: const BorderSide(color: HotelTokens.line),
      ),
      items: [
        _item(
          PdfPresentationMode.print,
          Icons.print_outlined,
          l10n.hotelQuotePrint,
        ),
        _item(
          PdfPresentationMode.download,
          Icons.download_outlined,
          l10n.hotelQuoteDownloadPdf,
        ),
        _item(PdfPresentationMode.share, Icons.ios_share, l10n.hotelShare),
      ],
    );
    if (choice == null || !context.mounted) return;
    // The presenter reports its own failures; no toast on top of it.
    await HotelFolioDocumentActions.present(context, stay, choice);
  }

  PopupMenuItem<PdfPresentationMode> _item(
    PdfPresentationMode mode,
    IconData icon,
    String label,
  ) {
    return PopupMenuItem<PdfPresentationMode>(
      value: mode,
      child: Row(
        children: [
          Icon(icon, size: 18, color: HotelTokens.ink2),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: HotelTokens.ink1,
            ),
          ),
        ],
      ),
    );
  }
}
