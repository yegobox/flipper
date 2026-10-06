import 'dart:typed_data';

import 'package:flipper_models/helpers/escpos_receipt.dart';
import 'package:flipper_models/helpers/receipt_totals.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart';

TransactionItem _item(
  String name, {
  required double price,
  double qty = 1,
  String? tax = 'B',
  double dcRt = 0,
  String? tt,
}) => TransactionItem(
  name: name,
  price: price,
  qty: qty,
  discount: 0,
  prc: price,
  ttCatCd: tt,
  taxTyCd: tax,
  dcRt: dcRt,
);

EscPosReceipt _receipt(
  List<TransactionItem> items, {
  String type = 'NS',
  bool fiscal = true,
}) => EscPosReceipt(
  items: items,
  receiptType: type,
  vatEnabled: true,
  totalDiscount: 0,
  taxA: 0,
  totalTax: (items.fold<double>(0, (s, i) => s + i.price * i.qty) * 18 / 118)
      .toStringAsFixed(2),
  brandName: 'Kigali Shop',
  brandAddress: 'KN 3 Rd',
  brandTel: '788123456',
  brandTIN: '123456789',
  brandEmail: 'shop@example.com',
  customerName: 'Walk-in Customer',
  paymentTypeCode: '01',
  invoiceNum: 42,
  saleDate: DateTime(2026, 10, 6, 12),
  whenCreated: DateTime(2026, 10, 6, 12, 30),
  isFiscalReceipt: fiscal,
  sdcId: 'SDC010000001',
  rcptNo: 12,
  totRcptNo: 34,
  internalData: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
  receiptSignature: 'ABCDEFGHIJKLMNOP',
  receiptQrCode: '20261006#SDC010000001#12/34/NS#ABCD#EFGH',
  mrc: 'WIS00000001',
);

/// The printable text of an ESC/POS stream: command bytes and raster data
/// dropped, one entry per printed line.
List<String> _textLines(Uint8List bytes) {
  final lines = <String>[];
  final line = StringBuffer();
  var i = 0;
  while (i < bytes.length) {
    final b = bytes[i];
    if (b == 0x1B) {
      // ESC @ is 2 bytes; ESC t/a/E/d take one argument.
      i += bytes[i + 1] == 0x40 ? 2 : 3;
    } else if (b == 0x1C) {
      i += 2; // FS . (leave Chinese mode)
    } else if (b == 0x1D) {
      final cmd = bytes[i + 1];
      if (cmd == 0x76) {
        final w = bytes[i + 4] | bytes[i + 5] << 8;
        final h = bytes[i + 6] | bytes[i + 7] << 8;
        i += 8 + w * h;
      } else if (cmd == 0x56) {
        i += 4;
      } else if (cmd == 0x28) {
        i += 5 + (bytes[i + 3] | bytes[i + 4] << 8);
      } else {
        i += 3; // GS !
      }
    } else if (b == 0x0A) {
      lines.add(line.toString());
      line.clear();
      i++;
    } else {
      line.writeCharCode(b);
      i++;
    }
  }
  return lines;
}

void main() {
  group('ReceiptTotals', () {
    test('B items: total, B-18% and the VAT inside it', () {
      final totals = ReceiptTotals(
        items: [_item('Soap', price: 1180), _item('Rice', price: 590, qty: 2)],
        receiptType: 'NS',
        vatEnabled: true,
        totalDiscount: 0,
        taxA: 0,
        totalTax: '360.00',
      );
      expect(totals.summary(), [
        (label: 'TOTAL:', value: '2,360.00'),
        (label: 'TOTAL B-18%:', value: '2,360.00'),
        (label: 'TOTAL TAX B:', value: '360.00'),
        (label: 'TOTAL TAX:', value: '360.00'),
      ]);
    });

    test('refunds print every amount negative', () {
      final totals = ReceiptTotals(
        items: [_item('Soap', price: 1180)],
        receiptType: 'NR',
        vatEnabled: true,
        totalDiscount: 0,
        taxA: 0,
        totalTax: '180.00',
      );
      expect(totals.summary().map((l) => l.value), [
        '-1,180.00',
        '-1,180.00',
        '-180.00',
        '-180.00',
      ]);
      expect(totals.paidAmount, '-1,180.00');
    });

    test('all-C receipts show a zero TOTAL TAX once', () {
      final totals = ReceiptTotals(
        items: [_item('Export', price: 500, tax: 'C')],
        receiptType: 'NS',
        vatEnabled: true,
        totalDiscount: 0,
        taxA: 0,
        totalTax: '0.00',
      );
      expect(totals.summary(), [
        (label: 'TOTAL:', value: '500.00'),
        (label: 'TOTAL C:', value: '500.00'),
        (label: 'TOTAL TAX:', value: '0.00'),
      ]);
    });

    test('discounts reduce the B base', () {
      final totals = ReceiptTotals(
        items: [_item('Soap', price: 1000, dcRt: 10)],
        receiptType: 'NS',
        vatEnabled: true,
        totalDiscount: 100,
        taxA: 0,
        totalTax: '137.29',
      );
      final lines = totals.summary();
      expect(lines.first, (label: 'TOTAL:', value: '900.00'));
      expect(lines[1], (label: 'TOTAL B-18%:', value: '900.00'));
    });
  });

  group('EscPosReceipt', () {
    test('fits 32 columns and carries every EBM field', () {
      final lines = _textLines(
        _receipt([
          _item('A product name long enough to wrap twice', price: 1180),
          _item('Rice', price: 590, qty: 2),
        ]).build(),
      );
      // Double-width brand lines are 16 characters.
      expect(lines.every((l) => l.length <= 32), isTrue, reason: '$lines');
      final text = lines.join('\n');
      for (final expected in [
        'Kigali Shop',
        'TIN: 123456789',
        'TEL: 0788123456',
        'SDC INFORMATION',
        'SDC010000001',
        '12 / 34 NS',
        'ABCD-EFGH-IJKL-MNOP-QRST-UVWX-YZ',
        'ABCD-EFGH-IJKL-MNOP',
        'WIS00000001',
        'TIME:12:30:00',
        'ITEMS NUMBER:',
        'THANK YOU',
      ]) {
        expect(text, contains(expected));
      }
      expect(text, contains('1180.00x 1'));
      expect(text, contains('590.00x 2'));
      expect(text, contains('1,180.00(B)'));
    });

    test('QR is sent as a raster image by default', () {
      final bytes = _receipt([_item('Soap', price: 1180)]).build();
      expect(_has(bytes, [0x1D, 0x76, 0x30]), isTrue);
      expect(_has(bytes, [0x1D, 0x28, 0x6B]), isFalse);
    });

    test('training and proforma receipts have no QR and say so', () {
      for (final type in ['TS', 'PS']) {
        final bytes = _receipt([
          _item('Soap', price: 1180),
        ], type: type).build();
        expect(_has(bytes, [0x1D, 0x76, 0x30]), isFalse, reason: type);
        expect(
          _textLines(bytes).join('\n'),
          contains('THIS IS NOT AN OFFICIAL RECEIPT'),
        );
      }
    });

    test('non-fiscal receipts omit SDC, QR and MRC', () {
      final text = _textLines(
        _receipt([_item('Soap', price: 1180)], fiscal: false).build(),
      ).join('\n');
      expect(text, isNot(contains('SDC')));
      expect(text, isNot(contains('MRC')));
      expect(text, isNot(contains('RRA VSDC')));
    });

    test('starts by leaving Chinese mode', () {
      final bytes = _receipt([_item('Soap', price: 1180)]).build();
      expect(bytes.sublist(0, 4), [0x1B, 0x40, 0x1C, 0x2E]);
    });

    test('ends with feed and cut', () {
      final bytes = _receipt([_item('Soap', price: 1180)]).build();
      expect(bytes.sublist(bytes.length - 4), [0x1D, 0x56, 0x42, 0x00]);
    });
  });
}

bool _has(List<int> hay, List<int> needle) {
  for (var i = 0; i <= hay.length - needle.length; i++) {
    var ok = true;
    for (var j = 0; j < needle.length && ok; j++) {
      ok = hay[i + j] == needle[j];
    }
    if (ok) return true;
  }
  return false;
}
