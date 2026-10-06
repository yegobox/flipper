import 'dart:typed_data';

import 'package:flipper_services/builtin_printer/printer_port_types.dart';
import 'package:flipper_services/builtin_printer/escpos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:qr/qr.dart';

void main() {
  group('EscPos commands', () {
    test('init resets, leaves Chinese mode and selects PC850', () {
      final p = EscPos()..init();
      expect(p.bytes(), [0x1B, 0x40, 0x1C, 0x2E, 0x1B, 0x74, 2]);
    });

    test('styled text resets its style after the line', () {
      final p = EscPos()
        ..text('HI', align: EscPosAlign.center, bold: true, height: 2);
      expect(p.bytes(), [
        0x1B, 0x61, 1, // centre
        0x1B, 0x45, 1, // bold on
        0x1D, 0x21, 0x01, // double height
        0x48, 0x49, 0x0A, // "HI\n"
        0x1D, 0x21, 0x00, // normal size
        0x1B, 0x45, 0, // bold off
        0x1B, 0x61, 0, // left
      ]);
    });

    test('cut feeds past the tear bar before GS V', () {
      final p = EscPos()..cut(feedLines: 4);
      expect(p.bytes(), [0x1B, 0x64, 4, 0x1D, 0x56, 0x42, 0x00]);
    });

    test('native QR uses GS ( k with the payload length', () {
      final bytes = (EscPos()..qr('ABC', mode: EscPosQrMode.native)).bytes();
      // Store command: pL pH = len(data) + 3.
      final store = [
        0x1D,
        0x28,
        0x6B,
        6,
        0,
        0x31,
        0x50,
        0x30,
        0x41,
        0x42,
        0x43,
      ];
      expect(_indexOf(bytes, store), isNonNegative);
    });
  });

  group('status reply', () {
    test('accepts a ready printer and rejects noise', () {
      expect(EscPos.statusQuery, [0x10, 0x04, 0x01]);
      expect(EscPos.isStatusReply(0x12), isTrue); // online, drawer low
      expect(EscPos.isStatusReply(0x16), isTrue); // drawer pin high
      expect(EscPos.isStatusReply(0x1A), isTrue); // offline bit set
      expect(EscPos.isStatusReply(0x00), isFalse);
      expect(EscPos.isStatusReply(0xFF), isFalse);
      expect(EscPos.isStatusReply(0x13), isFalse); // bit 0 must be clear
    });
  });

  group('text layout', () {
    test('row fits label and amount on one 32-column line', () {
      expect(EscPos.layoutRow('TOTAL:', '1,500.00', 32), [
        'TOTAL:                  1,500.00',
      ]);
    });

    test('row wraps a long label and keeps the amount right-aligned', () {
      final lines = EscPos.layoutRow(
        'A very long product name that cannot fit',
        '12,000.00(B)',
        32,
      );
      expect(lines.every((l) => l.length <= 32), isTrue);
      expect(lines.last.endsWith('12,000.00(B)'), isTrue);
    });

    test('wrap splits words longer than a line', () {
      final lines = EscPos.wrap('x' * 40, 32);
      expect(lines, ['x' * 32, 'x' * 8]);
    });

    test('encodes accents to PC850 and transliterates the rest', () {
      expect(EscPos.encodeText('é'), [0x82]);
      expect(EscPos.encodeText('Ç'), [0x80]);
      expect(EscPos.encodeText('“ok”'), '"ok"'.codeUnits);
      expect(EscPos.encodeText('€'), 'EUR'.codeUnits);
      expect(EscPos.encodeText('中'), '?'.codeUnits);
    });
  });

  group('raster', () {
    test(
      'QR bitmap is the code at whole dots per module with a quiet zone',
      () {
        const data = '20261006120000#SDC001#12/34/NS#ABCD#EFGH';
        final bitmap = EscPos.qrBitmap(data, moduleDots: 4);
        final qr = QrImage(
          QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.M),
        );
        expect(bitmap.width, (qr.moduleCount + 8) * 4);
        for (var row = 0; row < qr.moduleCount; row++) {
          for (var col = 0; col < qr.moduleCount; col++) {
            // Every dot of a module matches the module.
            final x = (col + 4) * 4, y = (row + 4) * 4;
            expect(bitmap.isBlack(x, y), qr.isDark(row, col));
            expect(bitmap.isBlack(x + 3, y + 3), qr.isDark(row, col));
          }
        }
        // Quiet zone stays white.
        expect(bitmap.isBlack(0, 0), isFalse);
      },
    );

    test('QR shrinks its module size rather than overflow the paper', () {
      final bitmap = EscPos.qrBitmap('x' * 200, moduleDots: 8, maxWidth: 384);
      expect(bitmap.width, lessThanOrEqualTo(384));
    });

    test('logo is scaled to at most 360 dots, never up', () {
      final big = img.Image(width: 1000, height: 200)
        ..clear(img.ColorRgb8(0, 0, 0));
      final small = img.Image(width: 100, height: 50)
        ..clear(img.ColorRgb8(255, 255, 255));
      final b = EscPos.logoBitmap(Uint8List.fromList(img.encodePng(big)))!;
      final s = EscPos.logoBitmap(Uint8List.fromList(img.encodePng(small)))!;
      expect(b.width, 360);
      expect(b.isBlack(10, 10), isTrue);
      expect(s.width, 100);
      expect(s.isBlack(10, 10), isFalse);
    });

    test('transparent logo pixels print as paper', () {
      final clear = img.Image(width: 20, height: 20, numChannels: 4)
        ..clear(img.ColorRgba8(0, 0, 0, 0));
      final b = EscPos.logoBitmap(Uint8List.fromList(img.encodePng(clear)))!;
      expect(b.isBlack(5, 5), isFalse);
    });

    test('images are centred on the full 384-dot line in bands', () {
      final logo = MonoBitmap(8, 30)..set(0, 0);
      final bytes = (EscPos()..image(logo, bandHeight: 24)).bytes();
      // First band header: GS v 0, 48 bytes wide, 24 rows.
      expect(bytes.sublist(0, 8), [0x1D, 0x76, 0x30, 0, 48, 0, 24, 0]);
      // The set pixel lands at x = (384 - 8) / 2 = 188 → byte 23, bit 4.
      expect(bytes[8 + 23], 0x80 >> 4);
      // Second band has the remaining 6 rows.
      expect(bytes.sublist(8 + 48 * 24, 8 + 48 * 24 + 8), [
        0x1D,
        0x76,
        0x30,
        0,
        48,
        0,
        6,
        0,
      ]);
    });
  });

  group('ports', () {
    test('parses VID/PID from registry keys and device paths', () {
      expect(parseVidPid('VID_1A86&PID_7523'), (vid: 0x1A86, pid: 0x7523));
      expect(parseVidPid(r'\\?\usb#vid_0416&pid_5011#6&2a#{28d78fad-5a12}'), (
        vid: 0x0416,
        pid: 0x5011,
      ));
      expect(parseVidPid('VID_0403+PID_6001+A1B2C3'), (
        vid: 0x0403,
        pid: 0x6001,
      ));
      expect(parseVidPid('ACPI\\PNP0501\\1'), isNull);
    });

    test('probe order: printer bridges, on-board UARTs, then the rest', () {
      final ports = [
        const SerialPortInfo(port: 'COM1', driverName: r'\Device\Serial0'),
        const SerialPortInfo(port: 'COM2', driverName: r'\Device\VCP0'),
        const SerialPortInfo(
          port: 'COM3',
          driverName: r'\Device\Serial2',
          vid: 0x1A86,
          pid: 0x7523,
        ),
        const SerialPortInfo(port: 'COM4', driverName: r'\Device\Serial1'),
      ];
      final ordered = orderSerialCandidates(ports, exclude: 'com4');
      expect(ordered.map((p) => p.port), ['COM3', 'COM1', 'COM2']);
    });

    test('only receipt-printer vendors are used without asking', () {
      expect(
        const UsbPrinterInfo(
          path: 'x',
          vid: 0x0416,
          pid: 0x5011,
        ).isKnownReceiptPrinter,
        isTrue,
      );
      // Epson also makes inkjets under the same vendor id.
      expect(
        const UsbPrinterInfo(
          path: 'x',
          vid: 0x04B8,
          pid: 0x0202,
        ).isKnownReceiptPrinter,
        isFalse,
      );
      // HP office printer.
      expect(
        const UsbPrinterInfo(
          path: 'x',
          vid: 0x03F0,
          pid: 0x1234,
        ).isKnownReceiptPrinter,
        isFalse,
      );
    });

    test('LPT status: attached only when SELECT is up and not unplugged', () {
      // Powered printer with paper: SELECT only.
      expect(const ParallelStatus(0x80).printerAttached, isTrue);
      expect(const ParallelStatus(0x80).ready, isTrue);
      // Out of paper: still a printer, but not ready.
      expect(const ParallelStatus(0x84).printerAttached, isTrue);
      expect(const ParallelStatus(0x84).problem, contains('paper'));
      // Nothing on the cable / powered off.
      expect(const ParallelStatus(0x00).printerAttached, isFalse);
      expect(const ParallelStatus(0xA0).printerAttached, isFalse);
      expect(const ParallelStatus(0x90).printerAttached, isFalse);
    });

    test('LPT writes are refused only on explicit flags, not SELECT low', () {
      expect(const ParallelStatus(0x00).problem, isNull);
      expect(const ParallelStatus(0x80).problem, isNull);
      expect(const ParallelStatus(0x10).problem, contains('off'));
      expect(const ParallelStatus(0x20).problem, contains('not connected'));
      expect(const ParallelStatus(0x04).problem, contains('paper'));
      expect(const ParallelStatus(0x08).problem, contains('offline'));
    });

    test('targets round-trip through the worker message', () {
      const serial = PrinterTarget.serial('COM3', 9600);
      const usb = PrinterTarget.usb(r'\\?\usb#vid_0416&pid_5011#x');
      expect(PrinterTarget.fromMessage(serial.toMessage(), 0), serial);
      expect(PrinterTarget.fromMessage(usb.toMessage(), 0), usb);
      const lpt = PrinterTarget.parallel('LPT1');
      expect(PrinterTarget.fromMessage(lpt.toMessage(), 0), lpt);
      expect(lpt.label, 'LPT1');
      expect(usb.label, 'USB 0416:5011');
      expect(serial.label, 'COM3 @ 9600');
    });
  });
}

int _indexOf(List<int> haystack, List<int> needle) {
  outer:
  for (var i = 0; i <= haystack.length - needle.length; i++) {
    for (var j = 0; j < needle.length; j++) {
      if (haystack[i + j] != needle[j]) continue outer;
    }
    return i;
  }
  return -1;
}
