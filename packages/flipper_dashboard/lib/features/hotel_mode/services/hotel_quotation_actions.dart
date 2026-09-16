import 'dart:typed_data';

import 'package:flipper_dashboard/features/hotel_mode/hotel_quotation_pdf.dart';
import 'package:flipper_dashboard/services/pdf_presentation_service.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/services/branch_document_settings_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_models/brick/models/business.model.dart';

/// Build / download / print / email a quotation PDF.
///
/// The composition root that gathers the business, branch and branch stamp,
/// modelled on `buildLocalSaleReceiptPdf` in
/// `services/transaction_receipt_actions_service.dart`.
abstract final class HotelQuotationActions {
  static Future<Uint8List> buildPdf(HotelQuotation quotation) async {
    final strategy = ProxyService.getStrategy(Strategy.capella);

    Business? business;
    try {
      business = await strategy.getBusiness(
        businessId: ProxyService.box.getBusinessId(),
      );
    } catch (_) {}

    String? branchName;
    final branchId = quotation.branchId.isNotEmpty
        ? quotation.branchId
        : ProxyService.box.getBranchId();
    if (branchId != null && branchId.isNotEmpty) {
      try {
        branchName = (await strategy.activeBranch(branchId: branchId)).name;
      } catch (_) {}
    }

    return HotelQuotationPdf.build(
      quotation: quotation,
      currency: ProxyService.box.defaultCurrency(),
      issuer: HotelQuotationIssuer(
        businessName: business?.name,
        branchName: branchName,
        tin: business?.tinNumber?.toString(),
        address: business?.adrs,
        phone: business?.phoneNumber,
        email: business?.email,
      ),
      // Read from the synchronous cache: the branch document is hydrated at
      // login, so a PDF never waits on Ditto to render its own letterhead.
      stamp: DocumentStamp.fromSettings(BranchDocumentSettingsService.current()),
    );
  }

  static String fileName(HotelQuotation quotation) =>
      '${quotation.reference}.pdf';

  /// Shared with the sale receipt, so a quotation reaches the same save
  /// dialog on desktop and the same viewer on mobile. It also owns the
  /// progress indicator and the double-tap guard, which building a PDF needs
  /// — rendering takes long enough that a silent button reads as broken.
  static final PdfPresentationService _presenter = PdfPresentationService();

  /// Desktop: a real save dialog. Mobile: writes to documents and opens it,
  /// falling back to the share sheet when no viewer is installed.
  static Future<void> download(
    BuildContext context,
    HotelQuotation quotation,
  ) => _present(context, quotation, PdfPresentationMode.download);

  /// The system print dialog — which on desktop also offers Save as PDF.
  static Future<void> print(BuildContext context, HotelQuotation quotation) =>
      _present(context, quotation, PdfPresentationMode.print);

  /// The OS share sheet, for sending the PDF somewhere else entirely.
  static Future<void> share(BuildContext context, HotelQuotation quotation) =>
      _present(context, quotation, PdfPresentationMode.share);

  static Future<void> _present(
    BuildContext context,
    HotelQuotation quotation,
    PdfPresentationMode mode,
  ) {
    return _presenter.present(
      context,
      mode: mode,
      progressMessage: 'Preparing quotation…',
      build: () => buildPdf(quotation),
      filename: () => fileName(quotation),
      label: 'Quotation',
      shareSubject: 'Quotation ${quotation.reference}',
    );
  }

  /// Subject line and body for the guest-facing email.
  static String emailSubject(HotelQuotation quotation, String? businessName) {
    final from = (businessName ?? '').trim();
    return from.isEmpty
        ? 'Quotation ${quotation.reference}'
        : 'Quotation ${quotation.reference} — $from';
  }

  static String emailHtml(HotelQuotation quotation, String? businessName) {
    final from = _escape(
      (businessName ?? '').trim().isEmpty ? 'us' : businessName!.trim(),
    );
    final guest = _escape(quotation.guestName);
    final nights = quotation.nights == 1 ? '1 night' : '${quotation.nights} nights';
    final validity = quotation.validUntil == null
        ? ''
        : '<p style="margin:0 0 16px;color:#4b5563;font-size:14px;">'
              'This quotation is valid until '
              '${_escape(_shortDate(quotation.validUntil!))}.</p>';

    return '<!DOCTYPE html><html><body style="margin:0;padding:0;background:#f3f4f6;">'
        '<table role="presentation" width="100%" cellpadding="0" cellspacing="0" '
        'style="background:#f3f4f6;padding:24px 12px;"><tr><td align="center">'
        '<table role="presentation" width="100%" cellpadding="0" cellspacing="0" '
        'style="max-width:560px;background:#ffffff;border-radius:12px;'
        'font-family:-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;">'
        '<tr><td style="padding:24px;">'
        '<div style="color:#111827;font-size:20px;font-weight:700;margin-bottom:8px;">'
        'Your quotation, ${_escape(quotation.reference)}</div>'
        '<p style="margin:0 0 16px;color:#4b5563;font-size:14px;line-height:1.55;">'
        'Hello $guest, thank you for considering $from. Your quotation for '
        'Room ${_escape(quotation.roomName)} over $nights is attached as a PDF.'
        '</p>'
        '$validity'
        '<p style="margin:0;color:#6b7280;font-size:13px;">'
        'A quotation holds no room until it is accepted — reply to this email '
        'or call us to confirm.</p>'
        '</td></tr></table></td></tr></table></body></html>';
  }

  static String emailPlain(HotelQuotation quotation, String? businessName) {
    final from = (businessName ?? '').trim();
    return 'Hello ${quotation.guestName},\n\n'
        'Thank you for considering ${from.isEmpty ? 'us' : from}. '
        'Your quotation ${quotation.reference} for Room ${quotation.roomName} '
        'is attached as a PDF.\n\n'
        '${quotation.validUntil == null ? '' : 'Valid until ${_shortDate(quotation.validUntil!)}.\n\n'}'
        'A quotation holds no room until it is accepted — reply or call us to '
        'confirm.';
  }

  /// Stable per version of the quotation: a double tap is deduplicated, while
  /// editing a quotation and resending it is not.
  static String idempotencyKey(HotelQuotation quotation) =>
      'quotation:${quotation.id}:sent:'
      '${quotation.updatedAt?.toUtc().toIso8601String() ?? 'new'}';

  static Future<String?> resolveBusinessName() async {
    try {
      final business = await ProxyService.getStrategy(
        Strategy.capella,
      ).getBusiness(businessId: ProxyService.box.getBusinessId());
      return business?.name;
    } catch (e) {
      talker.warning('hotel: could not resolve business name for quotation: $e');
      return null;
    }
  }

  static String _shortDate(DateTime value) {
    final local = value.toLocal();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${local.day} ${months[local.month - 1]} ${local.year}';
  }

  static String _escape(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}
