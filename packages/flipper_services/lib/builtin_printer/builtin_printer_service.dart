import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/builtin_printer/escpos.dart';
import 'package:flipper_services/builtin_printer/printer_port_stub.dart'
    if (dart.library.ffi) 'package:flipper_services/builtin_printer/printer_port_io.dart';
import 'package:flipper_services/customer_display/customer_display_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository/storage.dart';

export 'package:flipper_services/builtin_printer/printer_port_types.dart';

/// The 58 mm ESC/POS rendering of a receipt, attached to that receipt's PDF
/// bytes. The PDF is still what gets saved and uploaded; the printing step
/// sends these bytes instead when the till has a built-in printer.
final Expando<Uint8List> receiptEscPos = Expando<Uint8List>('receiptEscPos');

class BuiltinPrinterException implements Exception {
  BuiltinPrinterException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Prints receipts on a till's built-in thermal printer with raw ESC/POS —
/// no Windows printer driver, no spooler, no setup.
///
/// All-in-one tills (P70E and similar) wire their 58 mm printer to an
/// internal COM port or expose it as a USB printer-class device. Neither
/// needs a vendor driver, so a fresh install can print its first receipt.
///
/// The printer found is remembered device-locally (never synced: it is this
/// till's hardware).
class BuiltinPrinterService {
  BuiltinPrinterService(this._box);

  static final BuiltinPrinterService instance = BuiltinPrinterService(
    () => ProxyService.box,
  );

  /// Device-local settings storage, read lazily (the singleton outlives app
  /// boot order).
  final LocalStorage Function() _box;

  static const String transportKey = 'builtinPrinterTransport';
  static const String pathKey = 'builtinPrinterPath';
  static const String baudKey = 'builtinPrinterBaud';
  static const String qrModeKey = 'builtinPrinterQrMode';

  /// Stored in [transportKey] when the cashier turned the built-in printer
  /// off: never auto-detect again on this till.
  static const String _off = 'off';

  /// Speeds built-in printers ship at, most common first.
  static const List<int> bauds = [9600, 19200, 38400, 115200];

  static const String notFoundMessage =
      'Built-in printer not found. Check paper and restart.';

  Future<PrinterPortWorker?>? _worker;
  Future<PrinterTarget?>? _detecting;

  /// An automatic search this session found nothing: do not hold up every
  /// later sale searching again. Restarting (or Find printer) retries.
  bool _searchedEmpty = false;
  String? _logoSource;
  MonoBitmap? _logo;

  bool get isSupported => printerPortsSupported;

  /// A4 receipts were chosen in settings: those stay on the Windows printer.
  bool get receiptsUseA4 => _box().A4();

  /// The payment type code printed on receipts (`01` cash … `06` MoMo).
  String? get paymentTypeCode => _box().pmtTyCd();

  /// The MRC printed on receipts: the till's own when it is a full 11-char
  /// code, else the one on the receipt (same rule as the PDF).
  String resolveMrc(String receiptMrc) {
    final own = _box().mrc();
    return own != null && own.length == 11 ? own : receiptMrc;
  }

  /// The saved printer, if any.
  PrinterTarget? get savedTarget {
    final box = _box();
    final transport = box.readString(key: transportKey);
    final path = box.readString(key: pathKey);
    if (path == null || path.isEmpty) return null;
    if (transport == PrinterTransport.usb.name) return PrinterTarget.usb(path);
    if (transport == PrinterTransport.serial.name) {
      return PrinterTarget.serial(
        path,
        box.readInt(key: baudKey) ?? bauds.first,
      );
    }
    return null;
  }

  /// False once the cashier turned the built-in printer off.
  bool get autoDetectAllowed =>
      isSupported && _box().readString(key: transportKey) != _off;

  EscPosQrMode get qrMode =>
      _box().readString(key: qrModeKey) == EscPosQrMode.native.name
      ? EscPosQrMode.native
      : EscPosQrMode.raster;

  Future<void> setQrMode(EscPosQrMode mode) =>
      _box().writeString(key: qrModeKey, value: mode.name);

  Future<void> save(PrinterTarget target) async {
    final box = _box();
    await box.writeString(key: transportKey, value: target.transport.name);
    await box.writeString(key: pathKey, value: target.path);
    await box.writeInt(key: baudKey, value: target.baud);
    _searchedEmpty = false;
    await (await _worker)?.close();
  }

  /// Forgets the saved printer and stops auto-detection on this till.
  Future<void> turnOff() async {
    final box = _box();
    await box.writeString(key: transportKey, value: _off);
    await box.remove(key: pathKey);
    await box.remove(key: baudKey);
    await (await _worker)?.close();
  }

  /// Forgets the saved printer; the next receipt looks for one again.
  Future<void> forget() async {
    _searchedEmpty = false;
    final box = _box();
    await box.remove(key: transportKey);
    await box.remove(key: pathKey);
    await box.remove(key: baudKey);
    await (await _worker)?.close();
  }

  /// The saved printer, or one found now (and saved) when auto-detection is
  /// allowed. [includeUsb] also accepts a USB receipt printer, which cannot
  /// be confirmed with a status query; callers pass it only when Windows has
  /// no working printer of its own, so a driver-installed printer that
  /// already works is never taken over.
  Future<PrinterTarget?> ensureTarget({bool includeUsb = false}) async {
    final saved = savedTarget;
    if (saved != null) return saved;
    if (!autoDetectAllowed || _searchedEmpty) return null;
    final found = await (_detecting ??= detect(
      includeUsb: includeUsb,
    ).whenComplete(() => _detecting = null));
    if (found != null) {
      await save(found);
      talker.info('[builtin_printer] found ${found.label}');
    } else {
      _searchedEmpty = true;
      talker.info('[builtin_printer] no built-in printer answered');
    }
    return found;
  }

  /// Looks for a built-in printer without printing anything.
  ///
  /// COM ports are tried at each speed with `DLE EOT 1`; only a valid status
  /// byte counts, because serial writes "succeed" at any speed and a wrong
  /// one just prints garbage. Known USB-serial bridges and on-board UARTs go
  /// first; the customer display's port is skipped.
  Future<PrinterTarget?> detect({bool includeUsb = false}) async {
    if (!isSupported) return null;
    if (includeUsb) {
      for (final usb in listUsbPrinters()) {
        if (usb.isKnownReceiptPrinter) return PrinterTarget.usb(usb.path);
      }
    }
    final worker = await _spawn();
    if (worker == null) return null;
    final displayPort = CustomerDisplaySettings.read().port;
    final ports = orderSerialCandidates(
      describeSerialPorts(),
      exclude: displayPort,
    );
    try {
      for (final port in ports) {
        for (final baud in bauds) {
          final target = PrinterTarget.serial(port.port, baud);
          try {
            final reply = await worker.query(target, EscPos.statusQuery);
            if (reply != null && EscPos.isStatusReply(reply)) return target;
          } on PrinterPortException {
            // Will not open (absent, or held by another program): the other
            // speeds will not open either.
            break;
          }
        }
      }
      return null;
    } finally {
      await worker.close();
    }
  }

  /// Every port × speed and USB printer, for the cashier-confirmed search
  /// when no printer answers the status query.
  List<PrinterTarget> manualCandidates() {
    final displayPort = CustomerDisplaySettings.read().port;
    return [
      for (final usb in listUsbPrinters()) PrinterTarget.usb(usb.path),
      for (final port in orderSerialCandidates(
        describeSerialPorts(),
        exclude: displayPort,
      ))
        for (final baud in bauds) PrinterTarget.serial(port.port, baud),
    ];
  }

  /// Sends [bytes] to [target] (default: the saved printer).
  Future<void> print(Uint8List bytes, {PrinterTarget? target}) async {
    final to = target ?? savedTarget;
    if (to == null) throw BuiltinPrinterException(notFoundMessage);
    final worker = await _spawn();
    if (worker == null) throw BuiltinPrinterException(notFoundMessage);
    try {
      await worker.write(to, bytes);
    } on PrinterPortException catch (e) {
      talker.warning('[builtin_printer] ${to.label}: ${e.message}');
      throw BuiltinPrinterException('$notFoundMessage (${e.message})');
    }
  }

  /// Prints [escpos] on the built-in printer, finding it first if needed.
  /// Returns false (never throws) when there is none or it failed, so the
  /// caller can fall back to the Windows printer path.
  Future<bool> tryPrint(Uint8List escpos, {bool includeUsb = false}) async {
    try {
      final target = await ensureTarget(includeUsb: includeUsb);
      if (target == null) return false;
      await print(escpos, target: target);
      return true;
    } catch (e) {
      talker.warning('[builtin_printer] receipt not printed: $e');
      return false;
    }
  }

  /// One line naming [target], for the cashier-confirmed search.
  Future<String?> probePrint(PrinterTarget target) async {
    final p = EscPos()
      ..init()
      ..text('Flipper test ${target.label}', bold: true)
      ..feed(3);
    try {
      await print(p.bytes(), target: target);
      return null;
    } on BuiltinPrinterException catch (e) {
      return e.message;
    }
  }

  /// A full test page: fonts, the 32-column ruler, the logo and both QR
  /// renderings, so the cashier can see what this printer supports.
  Future<String?> testPrint({PrinterTarget? target}) async {
    final to = target ?? savedTarget;
    if (to == null) return notFoundMessage;
    final p = EscPos()..init();
    final logo = receiptLogo();
    if (logo != null) {
      p
        ..image(logo)
        ..feed();
    }
    p
      ..text(
        'FLIPPER TEST PRINT',
        align: EscPosAlign.center,
        bold: true,
        height: 2,
      )
      ..text(to.label, align: EscPosAlign.center)
      ..text(
        DateTime.now().toString().substring(0, 19),
        align: EscPosAlign.center,
      )
      ..rule()
      ..text('12345678901234567890123456789012')
      ..row('TOTAL:', '12,345.00', bold: true)
      ..text('Accents: é è à ç ô', align: EscPosAlign.left)
      ..rule()
      ..text('QR A (image)', align: EscPosAlign.center)
      ..qr('https://flipper.rw/test', mode: EscPosQrMode.raster)
      ..text('QR B (printer)', align: EscPosAlign.center)
      ..qr('https://flipper.rw/test', mode: EscPosQrMode.native)
      ..text('If QR B is missing, keep "image".', align: EscPosAlign.center)
      ..cut();
    try {
      await print(p.bytes(), target: to);
      return null;
    } on BuiltinPrinterException catch (e) {
      return e.message;
    }
  }

  /// The business logo from receipt settings, dithered for the printer.
  MonoBitmap? receiptLogo() {
    final source = _box().receiptLogoBase64();
    if (source == null || source.isEmpty) return null;
    if (source == _logoSource) return _logo;
    _logoSource = source;
    try {
      _logo = EscPos.logoBitmap(base64Decode(source));
    } catch (_) {
      _logo = null;
    }
    return _logo;
  }

  Future<PrinterPortWorker?> _spawn() => _worker ??= PrinterPortWorker.spawn();
}
