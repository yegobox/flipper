import 'package:flipper_models/helpers/receipt_printer_autoselect.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:printing/printing.dart';

Printer _p(String name, {bool isDefault = false, bool isAvailable = true}) =>
    Printer(
      url: name,
      name: name,
      isDefault: isDefault,
      isAvailable: isAvailable,
    );

void main() {
  // What Printing.listPrinters() returns on a P70E all-in-one till: one real
  // 58 mm printer among the Windows software printers, with Print to PDF as
  // the OS default.
  final p70e = <Printer>[
    _p('Microsoft Print to PDF', isDefault: true),
    _p('Microsoft XPS Document Writer'),
    _p('OneNote (Desktop)'),
    _p('Fax'),
    _p('AnyDesk Printer'),
    _p('POS-58'),
  ];

  group('pickAutoReceiptPrinter', () {
    test('adopts the one real printer among Windows software printers', () {
      expect(pickAutoReceiptPrinter(p70e)?.name, 'POS-58');
    });

    test('two real printers: the OS default wins', () {
      final printers = [...p70e, _p('EPSON TM-T20', isDefault: true)];
      expect(pickAutoReceiptPrinter(printers)?.name, 'EPSON TM-T20');
    });

    test('two real printers and no real default: ask the cashier', () {
      expect(pickAutoReceiptPrinter([...p70e, _p('EPSON TM-T20')]), isNull);
    });

    test('an offline real printer is not adopted', () {
      expect(
        pickAutoReceiptPrinter([
          _p('Microsoft Print to PDF', isDefault: true),
          _p('POS-58', isAvailable: false),
        ]),
        isNull,
      );
    });

    test('only software printers: ask the cashier', () {
      expect(pickAutoReceiptPrinter(p70e.take(5).toList()), isNull);
      expect(pickAutoReceiptPrinter(const []), isNull);
    });
  });

  test('isVirtualReceiptPrinter', () {
    expect(isVirtualReceiptPrinter(_p('Microsoft Print to PDF')), isTrue);
    expect(isVirtualReceiptPrinter(_p('Send To OneNote 2016')), isTrue);
    expect(isVirtualReceiptPrinter(_p('POS-80C')), isFalse);
    expect(isVirtualReceiptPrinter(_p('XP-58')), isFalse);
  });
}
