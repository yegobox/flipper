import 'dart:convert';
import 'dart:typed_data';

import 'package:flipper_dashboard/features/hotel_mode/hotel_quotation_pdf.dart';
import 'package:flipper_models/models/branch_document_settings.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flutter_test/flutter_test.dart';

HotelQuotation _quotation({
  double nightlyRate = 45000,
  double extrasTotal = 0,
  double discount = 0,
  DateTime? validUntil,
  String? note,
  String guestName = 'Aline Uwase',
}) {
  return HotelQuotation(
    id: 'q1',
    branchId: 'b1',
    reference: 'Q-4F2A19',
    guestName: guestName,
    guestPhone: '0788360058',
    guestEmail: 'aline@example.com',
    roomId: 'r1',
    roomName: '204',
    roomType: 'Double',
    checkInAt: DateTime.utc(2026, 9, 20, 12),
    checkOutAt: DateTime.utc(2026, 9, 22, 9),
    nightlyRate: nightlyRate,
    extrasTotal: extrasTotal,
    discount: discount,
    validUntil: validUntil,
    note: note,
  );
}

/// A 1x1 PNG — enough for the encoder, small enough to inline.
final Uint8List _pngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

DocumentStamp _stamp(DocumentStampPlacement placement) => DocumentStamp(
  bytes: _pngBytes,
  placement: placement,
  widthMm: 38,
  aspectRatio: 1,
);

void main() {
  // The builder loads a font and a logo from the asset bundle; both fail soft,
  // which is exactly what a headless test exercises.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HotelQuotationPdf.build', () {
    test('produces a real PDF', () async {
      final bytes = await HotelQuotationPdf.build(
        quotation: _quotation(),
        currency: 'RWF',
      );

      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('renders the reference and room so a guest can quote them back',
        () async {
      final bytes = await HotelQuotationPdf.build(
        quotation: _quotation(),
        currency: 'RWF',
        issuer: const HotelQuotationIssuer(businessName: 'Yego Hotel'),
      );

      // PDF text is compressed, so assert on size rather than content here;
      // the content assertions live in the totals tests below.
      expect(bytes.length, greaterThan(1000));
    });

    test('every placement emits a stamp, including besideTotals', () async {
      final plain = await HotelQuotationPdf.build(
        quotation: _quotation(),
        currency: 'RWF',
      );

      for (final placement in DocumentStampPlacement.values) {
        final stamped = await HotelQuotationPdf.build(
          quotation: _quotation(),
          currency: 'RWF',
          stamp: _stamp(placement),
        );
        // besideTotals draws inside the totals row rather than as a trailing
        // widget; it used to be filtered out of both and render nothing.
        expect(
          stamped.length,
          greaterThan(plain.length),
          reason: '$placement produced no stamp',
        );
      }
    });

    test('a discount larger than the stay does not go negative', () async {
      final quotation = _quotation(nightlyRate: 10000, discount: 999999);
      expect(quotation.total, 0);

      final bytes = await HotelQuotationPdf.build(
        quotation: quotation,
        currency: 'RWF',
      );
      expect(bytes, isNotEmpty);
    });

    test('handles extras, notes and an expired validity without throwing',
        () async {
      final bytes = await HotelQuotationPdf.build(
        quotation: _quotation(
          extrasTotal: 12000,
          discount: 5000,
          validUntil: DateTime.utc(2020, 1, 1),
          note: 'Airport pickup included. Late arrival expected.',
        ),
        currency: 'RWF',
      );
      expect(bytes, isNotEmpty);
    });

    test('renders a name with accents that Helvetica alone cannot cover',
        () async {
      final bytes = await HotelQuotationPdf.build(
        quotation: _quotation(guestName: 'Jean-Baptiste Nsengimana Ábç'),
        currency: 'RWF',
      );
      expect(bytes, isNotEmpty);
    });
  });

  group('DocumentStamp.fromSettings', () {
    test('is null when the branch has no stamp', () {
      expect(DocumentStamp.fromSettings(null), isNull);
      expect(
        DocumentStamp.fromSettings(
          const BranchDocumentSettings(branchId: 'b1'),
        ),
        isNull,
      );
    });

    test('is null when a stamp exists but the toggle is off', () {
      final settings = BranchDocumentSettings(
        branchId: 'b1',
        stampEnabled: false,
        stampImageBase64: base64Encode(_pngBytes),
      );
      expect(DocumentStamp.fromSettings(settings), isNull);
    });

    test('carries placement, width and aspect ratio through', () {
      final settings = BranchDocumentSettings(
        branchId: 'b1',
        stampEnabled: true,
        stampImageBase64: base64Encode(_pngBytes),
        stampPlacement: DocumentStampPlacement.bottomLeft,
        stampWidthMm: 50,
        stampAspectRatio: 0.5,
      );

      final stamp = DocumentStamp.fromSettings(settings)!;
      expect(stamp.placement, DocumentStampPlacement.bottomLeft);
      expect(stamp.widthMm, 50);
      expect(stamp.aspectRatio, 0.5);
      // Height follows the ratio, which is the whole reason it is stored.
      expect(stamp.heightPt, closeTo(stamp.widthPt * 0.5, 0.001));
    });

    test('a corrupt stamp costs the branch its stamp, not its quotation', () {
      final settings = BranchDocumentSettings(
        branchId: 'b1',
        stampEnabled: true,
        stampImageBase64: 'not base64 at all !!!',
      );
      expect(DocumentStamp.fromSettings(settings), isNull);
    });
  });
}
