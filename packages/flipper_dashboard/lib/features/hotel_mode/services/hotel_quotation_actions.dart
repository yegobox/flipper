import 'dart:async';
import 'dart:typed_data';

import 'package:flipper_dashboard/features/hotel_mode/hotel_quotation_pdf.dart';
import 'package:flipper_dashboard/services/pdf_presentation_service.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/services/branch_document_settings_service.dart';
import 'package:flipper_models/services/tenant_name_sync.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_models/brick/models/branch.model.dart';

/// Build / download / print / email a quotation PDF.
///
/// The composition root that gathers the business, branch and branch stamp,
/// modelled on `buildLocalSaleReceiptPdf` in
/// `services/transaction_receipt_actions_service.dart`.
abstract final class HotelQuotationActions {
  /// Renders [quotation].
  ///
  /// Download and print must be instant and offline: they never wait on the
  /// network, and draw the letterhead [warmUp] prepared when the desk opened.
  /// Only when that is missing do they read the local copies, each under
  /// [_localReadBudget] — the Ditto store on a busy desk has been seen taking
  /// over 5s for one branch lookup, and a letterhead line is not worth a
  /// document that never arrives. [awaitFreshNames] is for email, which needs
  /// the network anyway: it briefly waits for the names Supabase has.
  static Future<Uint8List> buildPdf(
    HotelQuotation quotation, {
    bool awaitFreshNames = false,
  }) async {
    final branchId = quotation.branchId.isNotEmpty
        ? quotation.branchId
        : ProxyService.box.getBranchId();

    final HotelQuotationIssuer issuer;
    if (awaitFreshNames) {
      issuer = await _resolveIssuer(branchId, await _freshTenantNames());
    } else {
      issuer = _cachedIssuer(branchId) ??
          await _resolveIssuer(branchId, _lastFetchedNames);
      // Refresh for the next document; this one does not wait for it.
      unawaited(warmUp());
    }

    return HotelQuotationPdf.build(
      quotation: quotation,
      currency: ProxyService.box.defaultCurrency(),
      issuer: issuer,
      // Settings come from the synchronous cache hydrated at login; the photo
      // is keyed out off the UI isolate and cached (warmUp primes it).
      stamp: await DocumentStamp.resolve(
        BranchDocumentSettingsService.current(),
      ),
    );
  }

  /// Prepares the letterhead and stamp so the next document renders at once.
  ///
  /// Local copies first, so an offline desk is ready too; then, if Supabase
  /// answers, the current names (which also patches the local copies in the
  /// background). Called when Hotel Mode opens and after every document.
  /// Throttled; never throws.
  static Future<void> warmUp() async {
    final now = DateTime.now();
    final last = _warmedAt;
    if (last != null && now.difference(last) < _warmUpInterval) return;
    _warmedAt = now;

    final branchId = ProxyService.box.getBranchId();
    try {
      unawaited(
        DocumentStamp.resolve(BranchDocumentSettingsService.current()),
      );
      await _resolveIssuer(branchId, _lastFetchedNames);
      final fresh = await _freshTenantNames();
      if (fresh != null) await _resolveIssuer(branchId, fresh);
    } catch (e) {
      talker.warning('hotel: quotation letterhead not prepared: $e');
    }
  }

  static const Duration _warmUpInterval = Duration(seconds: 60);
  static const Duration _localReadBudget = Duration(milliseconds: 1500);
  static DateTime? _warmedAt;

  static HotelQuotationIssuer? _issuer;
  static String? _issuerKey;

  static String _issuerKeyFor(String? branchId) =>
      '${ProxyService.box.getBusinessId()}|$branchId';

  static HotelQuotationIssuer? _cachedIssuer(String? branchId) =>
      _issuerKey == _issuerKeyFor(branchId) ? _issuer : null;

  /// Reads the business and branch from the local copies, in parallel and
  /// bounded, preferring names in [fresh]. Cached only when the business was
  /// found, so a timed-out read is retried rather than remembered.
  static Future<HotelQuotationIssuer> _resolveIssuer(
    String? branchId,
    TenantNames? fresh,
  ) async {
    final strategy = ProxyService.getStrategy(Strategy.capella);
    final businessId = ProxyService.box.getBusinessId();
    final names = fresh != null && fresh.businessId == businessId
        ? fresh
        : null;
    final hasBranch = branchId != null && branchId.isNotEmpty;
    final freshBranchName = hasBranch ? names?.branchNames[branchId] : null;

    final (business, branch) = await (
      _bounded(strategy.getBusiness(businessId: businessId)),
      freshBranchName == null && hasBranch
          ? _bounded(strategy.activeBranch(branchId: branchId))
          : Future<Branch?>.value(null),
    ).wait;

    final issuer = HotelQuotationIssuer(
      businessName: names?.businessName ?? business?.name,
      branchName: freshBranchName ?? branch?.name,
      tin: business?.tinNumber?.toString(),
      address: business?.adrs,
      phone: business?.phoneNumber,
      email: business?.email,
    );
    if (business != null) {
      _issuer = issuer;
      _issuerKey = _issuerKeyFor(branchId);
    }
    return issuer;
  }

  static Future<T?> _bounded<T>(Future<T?> read) => read
      .timeout(_localReadBudget)
      .then<T?>((value) => value, onError: (Object _) => null);

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

  /// Current business/branch names from Supabase, for the letterhead.
  ///
  /// The realtime rename sync lives in the POS `DashboardLayout` and its
  /// resume catch-up in `FlipperApp`; switching into Hotel Mode with
  /// `replaceWith` unmounts both, so a desk terminal could print a renamed
  /// business under its old name indefinitely.
  ///
  /// Only the network fetch is awaited. Writing the names into Brick, the
  /// Ditto docs and `user_access` is several sequential Ditto round trips,
  /// which on a busy store took longer than the document was willing to
  /// wait — so the document uses the fetched names directly and the local
  /// copies are patched in the background. Shared for a few seconds so Send
  /// (subject + PDF) costs one fetch. Offline or slow: null, and callers keep
  /// the names already on the device.
  static TenantNames? _lastFetchedNames;
  static Future<TenantNames?>? _namesFetch;
  static DateTime? _namesFetchedAt;

  static Future<TenantNames?> _freshTenantNames() {
    final at = _namesFetchedAt;
    final pending = _namesFetch;
    if (pending != null &&
        at != null &&
        DateTime.now().difference(at) < const Duration(seconds: 15)) {
      return pending;
    }
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null || businessId.isEmpty) return Future.value(null);

    _namesFetchedAt = DateTime.now();
    return _namesFetch = TenantNameSync.fetchNames(businessId: businessId)
        .timeout(const Duration(seconds: 2))
        .then<TenantNames?>((names) {
      _lastFetchedNames = names;
      unawaited(TenantNameSync.applyNames(names).catchError((Object e) {
        talker.warning('hotel: local tenant names not patched: $e');
        return false;
      }));
      return names;
    }, onError: (Object e) {
      talker.warning('hotel: using cached names for quotation: $e');
      return null;
    });
  }

  static Future<String?> resolveBusinessName() async {
    final fresh = await _freshTenantNames();
    if (fresh?.businessName != null) return fresh!.businessName;
    final cached = _cachedIssuer(ProxyService.box.getBranchId())?.businessName;
    if (cached != null) return cached;
    final business = await _bounded(
      ProxyService.getStrategy(Strategy.capella)
          .getBusiness(businessId: ProxyService.box.getBusinessId()),
    );
    return business?.name;
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
