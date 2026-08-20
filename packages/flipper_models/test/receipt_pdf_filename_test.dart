import 'package:flipper_models/helpers/receipt_pdf_filename.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildReceiptPdfFilename', () {
    test('uses customer name and creation timestamp', () {
      final name = buildReceiptPdfFilename(
        customerName: 'John Doe',
        createdAt: DateTime(2026, 8, 8, 14, 30, 12),
      );

      expect(name, 'John_Doe-20260808_143012.pdf');
    });

    test('strips characters that are unsafe in a filename', () {
      final name = buildReceiptPdfFilename(
        customerName: '  Acme / Ltd.  ',
        createdAt: DateTime(2026, 1, 2, 3, 4, 5),
      );

      expect(name, 'Acme_Ltd-20260102_030405.pdf');
    });

    test('falls back to the prefix when there is no customer', () {
      final name = buildReceiptPdfFilename(
        customerName: '   ',
        createdAt: DateTime(2026, 12, 31, 23, 59, 59),
      );

      expect(name, 'receipt-20261231_235959.pdf');
    });

    test('two sales at different times never collide', () {
      final first = buildReceiptPdfFilename(
        customerName: 'John Doe',
        createdAt: DateTime(2026, 8, 8, 14, 30, 12),
      );
      final second = buildReceiptPdfFilename(
        customerName: 'John Doe',
        createdAt: DateTime(2026, 8, 8, 14, 30, 13),
      );

      expect(first, isNot(second));
    });

    test('caps very long customer names', () {
      final name = buildReceiptPdfFilename(
        customerName: 'A' * 120,
        createdAt: DateTime(2026, 8, 8, 14, 30, 12),
      );

      expect(name, '${'A' * 40}-20260808_143012.pdf');
    });

    test('uses now when the transaction has no timestamp', () {
      final name = buildReceiptPdfFilename(
        customerName: 'Jane',
        now: DateTime(2026, 5, 6, 7, 8, 9),
      );

      expect(name, 'Jane-20260506_070809.pdf');
    });
  });
}
