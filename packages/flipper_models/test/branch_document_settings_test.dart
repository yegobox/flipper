import 'package:flipper_models/models/branch_document_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BranchDocumentSettings', () {
    test('a fresh branch has no stamp', () {
      const settings = BranchDocumentSettings(branchId: 'b1');
      expect(settings.stampEnabled, isFalse);
      expect(settings.stampImageBase64, isNull);
      expect(settings.hasStamp, isFalse);
    });

    test('hasStamp needs both an image and the toggle', () {
      const imageOnly = BranchDocumentSettings(
        branchId: 'b1',
        stampImageBase64: 'abc',
      );
      const toggleOnly = BranchDocumentSettings(
        branchId: 'b1',
        stampEnabled: true,
      );
      const both = BranchDocumentSettings(
        branchId: 'b1',
        stampEnabled: true,
        stampImageBase64: 'abc',
      );
      expect(imageOnly.hasStamp, isFalse);
      expect(toggleOnly.hasStamp, isFalse);
      expect(both.hasStamp, isTrue);
    });

    test('serialises the stamp image even when null', () {
      // Ditto's ON ID CONFLICT DO UPDATE leaves omitted fields untouched, so
      // omitting a removed stamp would keep printing it on every other device.
      const settings = BranchDocumentSettings(branchId: 'b1');
      final json = settings.toJson();
      expect(json.containsKey('stampImageBase64'), isTrue);
      expect(json['stampImageBase64'], isNull);
    });

    test('clearStampImage actually clears it', () {
      const settings = BranchDocumentSettings(
        branchId: 'b1',
        stampImageBase64: 'abc',
      );
      expect(
        settings.copyWith(stampImageBase64: null).stampImageBase64,
        'abc',
        reason: 'copyWith cannot express null; that is why the flag exists',
      );
      expect(settings.copyWith(clearStampImage: true).stampImageBase64, isNull);
    });

    test('survives a round trip', () {
      const settings = BranchDocumentSettings(
        branchId: 'b1',
        stampEnabled: true,
        stampImageBase64: 'iVBORw0KGgo=',
        stampPlacement: DocumentStampPlacement.besideTotals,
        stampWidthMm: 52,
        stampAspectRatio: 0.42,
      );
      final parsed = BranchDocumentSettings.fromJson(settings.toJson());
      expect(parsed.branchId, 'b1');
      expect(parsed.stampEnabled, isTrue);
      expect(parsed.stampImageBase64, 'iVBORw0KGgo=');
      expect(parsed.stampPlacement, DocumentStampPlacement.besideTotals);
      expect(parsed.stampWidthMm, 52);
      expect(parsed.stampAspectRatio, closeTo(0.42, 0.0001));
    });

    test('_id is the branch id, so one document per branch', () {
      const settings = BranchDocumentSettings(branchId: 'b1');
      expect(settings.toJson()['_id'], 'b1');
    });

    test('survives Ditto string coercion', () {
      final parsed = BranchDocumentSettings.fromJson({
        'branchId': 'b1',
        'stampEnabled': 'true',
        'stampWidthMm': '44',
        'stampAspectRatio': '0.5',
        'stampPlacement': 'bottomLeft',
      });
      expect(parsed.stampEnabled, isTrue);
      expect(parsed.stampWidthMm, 44);
      expect(parsed.stampAspectRatio, 0.5);
      expect(parsed.stampPlacement, DocumentStampPlacement.bottomLeft);
    });

    test('an out-of-range width is clamped rather than trusted', () {
      expect(
        BranchDocumentSettings.fromJson({
          'branchId': 'b1',
          'stampWidthMm': 500,
        }).stampWidthMm,
        BranchDocumentSettings.maxStampWidthMm,
      );
      expect(
        BranchDocumentSettings.fromJson({
          'branchId': 'b1',
          'stampWidthMm': 1,
        }).stampWidthMm,
        BranchDocumentSettings.minStampWidthMm,
      );
    });

    test('a nonsense aspect ratio falls back to square, not to invisible', () {
      for (final bad in [0, -3, 'abc', null]) {
        final parsed = BranchDocumentSettings.fromJson({
          'branchId': 'b1',
          'stampAspectRatio': bad,
        });
        expect(parsed.stampAspectRatio, 1.0, reason: 'input $bad');
      }
    });

    test('American spelling of the placement is accepted', () {
      // Nothing writes it today, but a hand-edited document should not
      // silently fall back to a different corner.
      expect(
        documentStampPlacementFromString('bottomCenter'),
        DocumentStampPlacement.bottomCentre,
      );
      expect(
        documentStampPlacementFromString('nonsense'),
        DocumentStampPlacement.bottomRight,
      );
    });

    test('an empty stored image reads back as no image', () {
      final parsed = BranchDocumentSettings.fromJson({
        'branchId': 'b1',
        'stampEnabled': true,
        'stampImageBase64': '',
      });
      expect(parsed.stampImageBase64, isNull);
      expect(parsed.hasStamp, isFalse);
    });
  });
}
