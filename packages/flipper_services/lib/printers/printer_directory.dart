import 'dart:async';

import 'package:flipper_services/printers/printer_enum_stub.dart'
    if (dart.library.ffi) 'package:flipper_services/printers/printer_enum_io.dart';
import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';

/// Longest wait for the OS printer list before callers carry on with none.
const Duration printerListTimeout = Duration(seconds: 10);

/// How long a printer list is reused before the OS is asked again.
const Duration _cacheFor = Duration(seconds: 60);

Future<List<Printer>>? _inFlight;
List<Printer>? _cached;
DateTime? _cachedAt;

/// Replaces the OS lookup in tests.
@visibleForTesting
Future<List<Printer>> Function()? debugPrinterLister;

@visibleForTesting
void debugResetPrinterDirectory() {
  _inFlight = null;
  _cached = null;
  _cachedAt = null;
  debugPrinterLister = null;
}

/// The printers this till can print to, without blocking the UI thread.
///
/// Every caller (Admin → Till hardware, receipt auto-print, the print picker)
/// shares one lookup: concurrent calls join the one in flight, and a result is
/// reused for a minute. Pass [refresh] where a printer added moments ago must
/// show up. Throws [TimeoutException] after [printerListTimeout]; failures are
/// not cached.
///
/// The timeout bounds each caller's wait, not the lookup: a timeout cannot
/// cancel the native call, so the lookup stays shared until it really ends and
/// later callers join it instead of starting another blocked enumeration.
Future<List<Printer>> listPrintersSafely({bool refresh = false}) {
  final cached = _cached;
  final cachedAt = _cachedAt;
  if (!refresh &&
      cached != null &&
      cachedAt != null &&
      DateTime.now().difference(cachedAt) < _cacheFor) {
    return Future.value(cached);
  }
  final lookup = _inFlight ??= _lookup().whenComplete(() => _inFlight = null);
  return lookup.timeout(printerListTimeout);
}

Future<List<Printer>> _lookup() async {
  final printers = await (debugPrinterLister ?? _osPrinters)();
  _cached = printers;
  _cachedAt = DateTime.now();
  return printers;
}

Future<List<Printer>> _osPrinters() async =>
    await enumerateNativePrinters() ?? await Printing.listPrinters();
