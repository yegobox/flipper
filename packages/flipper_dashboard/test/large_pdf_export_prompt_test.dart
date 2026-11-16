import 'package:flipper_dashboard/export/large_pdf_export_prompt.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shouldOfferExcelForPdf', () {
    test('only a PDF above the limit asks', () {
      expect(
        shouldOfferExcelForPdf(
          asPdf: true,
          rowCount: kLargePdfExportRowLimit + 1,
        ),
        isTrue,
      );
      expect(
        shouldOfferExcelForPdf(asPdf: true, rowCount: kLargePdfExportRowLimit),
        isFalse,
        reason: 'reports up to the limit export exactly as before',
      );
      expect(
        shouldOfferExcelForPdf(asPdf: false, rowCount: 999999),
        isFalse,
        reason: 'Excel exports never ask',
      );
      expect(
        shouldOfferExcelForPdf(asPdf: true, rowCount: null),
        isFalse,
        reason: 'no grid (headless export) never asks',
      );
    });
  });

  group('showLargePdfExportPrompt', () {
    Future<LargePdfExportChoice?> open(
      WidgetTester tester,
      Future<void> Function() act,
    ) async {
      LargePdfExportChoice? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async => result = await showLargePdfExportPrompt(
                context,
                rowCount: 12345,
              ),
              child: const Text('export'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('export'));
      await tester.pumpAndSettle();
      expect(find.textContaining('12345 rows'), findsOneWidget);
      await act();
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('Export Excel picks Excel', (tester) async {
      expect(
        await open(
          tester,
          () => tester.tap(find.byKey(const Key('largePdfUseExcel'))),
        ),
        LargePdfExportChoice.excel,
      );
    });

    testWidgets('PDF anyway keeps the PDF', (tester) async {
      expect(
        await open(
          tester,
          () => tester.tap(find.byKey(const Key('largePdfAnyway'))),
        ),
        LargePdfExportChoice.pdf,
      );
    });

    testWidgets('Cancel cancels', (tester) async {
      expect(
        await open(
          tester,
          () => tester.tap(find.byKey(const Key('largePdfCancel'))),
        ),
        LargePdfExportChoice.cancel,
      );
    });

    testWidgets('dismissing the dialog cancels', (tester) async {
      expect(
        await open(tester, () => tester.tapAt(const Offset(5, 5))),
        LargePdfExportChoice.cancel,
      );
    });
  });
}
